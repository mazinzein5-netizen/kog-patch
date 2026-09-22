#!/data/data/com.termux/files/usr/bin/bash
# KOG LLM tunnel v1 - secure public endpoint for llama-server
# Safe: only touches the kog-mcp tunnel process, never other tunnels.
set -u

HOST="llm.agentzein.dev"
PORT=11435
CFG="$HOME/.cloudflared/config.yml"
KEYF="$HOME/.llm_api_key"
SL="$HOME/models/start-llama.sh"
CF="$(command -v cloudflared || true)"
LOG="$HOME/llm_tunnel_v1.log"
: > "$LOG"
say() { printf '%s\n' "$*" | tee -a "$LOG"; }

say "LLM-TUNNEL-V1-START"
say "DATE=$(date '+%Y-%m-%d %H:%M')"
UUID=$(awk '/^tunnel:/{print $2}' "$CFG" 2>/dev/null)
say "tunnel_uuid=$UUID"
if [ -z "$UUID" ]; then say "FATAL=no_tunnel_uuid_in_config"; say "LLM-TUNNEL-V1-END"; exit 1; fi

# ---------- 1. API key (value never printed) ----------
if [ -s "$KEYF" ]; then
  say "[1] KEY=EXISTS_REUSED file=$KEYF"
else
  K=$(tr -dc 'a-f0-9' < /dev/urandom | head -c 48)
  ( umask 077; printf '%s' "$K" > "$KEYF" )
  chmod 600 "$KEYF"
  say "[1] KEY=GENERATED file=$KEYF"
fi
if [ -s "$KEYF" ]; then say "[1] key_bytes=$(wc -c < "$KEYF")"; else say "[1] KEY=MISSING"; fi

# ---------- 2. patch start-llama.sh (auth ON before exposure) ----------
if grep -q -- '--api-key-file' "$SL" 2>/dev/null; then
  say "[2] PATCH=ALREADY_PRESENT"
else
  cp -p "$SL" "$SL.bak_llm_v1"
  N=$(grep -c -- '-c 2048 ' "$SL" 2>/dev/null)
  N=${N:-0}
  say "[2] anchor_matches=$N"
  if [ "$N" = "1" ]; then
    sed -i 's|-c 2048 |-c 2048 --api-key-file "$HOME/.llm_api_key" |' "$SL"
    if grep -q -- '--api-key-file' "$SL"; then say "[2] PATCH=OK"; else say "[2] PATCH=FAILED"; fi
  else
    say "[2] PATCH=SKIPPED_anchor_not_unique"
  fi
fi
say "[2] flags=$(grep -o -- '-c 2048[^>]*' "$SL" | head -1)"

# ---------- 3. ingress (insert before catch-all) ----------
if grep -q "$HOST" "$CFG" 2>/dev/null; then
  say "[3] INGRESS=ALREADY_PRESENT"
else
  cp -p "$CFG" "$CFG.bak_llm_v1"
  awk -v h="$HOST" -v p="$PORT" '
    /- service: http_status:404/ && !d { print "  - hostname: " h; print "    service: http://127.0.0.1:" p; d=1 }
    { print }
  ' "$CFG.bak_llm_v1" > "$CFG"
  say "[3] INGRESS=ADDED"
fi
say "[3] hostname_count=$(grep -c 'hostname:' "$CFG")"
say "[3] catchall_last=$(tail -1 "$CFG")"

# ---------- 4. DNS route ----------
if [ -n "${CF:-}" ]; then
  timeout 45 "$CF" tunnel route dns "$UUID" "$HOST" > "$HOME/dns_route.log" 2>&1
  say "[4] route_exit=$?"
  grep -iE 'added|exist|error|created' "$HOME/dns_route.log" 2>/dev/null | head -2 | sed 's/^/    /' | tee -a "$LOG"
fi

# ---------- 5. restart llama-server with auth ----------
pkill -f 'llama-server' 2>/dev/null
sleep 3
setsid nohup bash "$SL" > "$HOME/models/start_out.log" 2>&1 < /dev/null &
say "[5] restarting llama-server"
H="000"
for i in $(seq 1 20); do
  sleep 5
  H=$(curl -s -m 4 -o /dev/null -w '%{http_code}' "http://127.0.0.1:$PORT/health" 2>/dev/null || true)
  say "[5] wait $i health=${H:-000}"
  [ "${H:-}" = "200" ] && break
done

KEY=$(cat "$KEYF")
NA=$(curl -s -m 6 -o /dev/null -w '%{http_code}' "http://127.0.0.1:$PORT/v1/models" 2>/dev/null || true)
AU=$(curl -s -m 8 -o /dev/null -w '%{http_code}' -H "Authorization: Bearer $KEY" "http://127.0.0.1:$PORT/v1/models" 2>/dev/null || true)
say "[5] LOCAL_NOAUTH=${NA:-000} expect_401"
say "[5] LOCAL_WITHAUTH=${AU:-000} expect_200"

# ---------- 6. start ONLY the kog-mcp tunnel ----------
say "[6] cloudflared processes found before start:"
pgrep -af cloudflared 2>/dev/null | sed 's/^/    /' | tee -a "$LOG"
if [ -n "${CF:-}" ]; then
  for pid in $(pgrep -f cloudflared 2>/dev/null); do
    CL=$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null || true)
    case "$CL" in
      *"$UUID"*) say "[6] stopping OUR tunnel pid=$pid"; kill "$pid" 2>/dev/null ;;
      *) say "[6] sparing other tunnel pid=$pid";;
    esac
  done
  sleep 3
  setsid nohup "$CF" tunnel --config "$CFG" run "$UUID" > "$HOME/cloudflared_llm.log" 2>&1 < /dev/null &
  say "[6] cloudflared starting"
  for i in $(seq 1 10); do
    sleep 4
    if grep -q 'Registered tunnel connection' "$HOME/cloudflared_llm.log" 2>/dev/null; then say "[6] CONNECTED at attempt $i"; break; fi
    say "[6] attempt $i ..."
  done
  say "[6] conns=$(grep -c 'Registered tunnel connection' "$HOME/cloudflared_llm.log" 2>/dev/null)"
fi

# ---------- 7. public verify ----------
for i in $(seq 1 6); do
  sleep 6
  P=$(curl -s -m 20 -o /dev/null -w '%{http_code}' -H "Authorization: Bearer $KEY" "https://$HOST/v1/models" 2>/dev/null || true)
  say "[7] public attempt $i http=${P:-000}"
  [ "${P:-}" = "200" ] && break
done

say "--- SUMMARY ---"
say "HOST=$HOST"
say "KEY_FILE=$KEYF  (read it with: cat $KEYF)"
say "BAK_CONFIG=$CFG.bak_llm_v1"
say "BAK_START=$SL.bak_llm_v1"
say "LLM-TUNNEL-V1-END"
