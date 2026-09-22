#!/data/data/com.termux/files/usr/bin/bash
# KOG Tunnel Phase 0 - READ ONLY recon. Changes nothing on the device.
LOG="$HOME/tunnel_v1.log"
: > "$LOG"
P="${PREFIX:-/data/data/com.termux/files/usr}"
LS="$P/lib/ollama/llama-server"

{
echo "TUNNEL-V1-START"
echo "DATE=$(date '+%Y-%m-%d %H:%M')"
echo "PREFIX=$P"

echo "--- 1. llama-server binary ---"
if [ -x "$LS" ]; then LS_OK=yes; echo "BIN=OK"; else LS_OK=no; echo "BIN=MISSING"; fi

echo "--- 2. --api-key support ---"
if [ "$LS_OK" = yes ]; then
  AK=$(LD_LIBRARY_PATH="$P/lib/ollama" "$LS" --help 2>&1 | grep -c -- '--api-key')
  echo "APIKEY_MATCHES=$AK"
  LD_LIBRARY_PATH="$P/lib/ollama" "$LS" --help 2>&1 | grep -- '--api-key' | head -1
else
  AK=0; echo "APIKEY_MATCHES=0"
fi

echo "--- 3. cloudflared ---"
CF=$(command -v cloudflared || true)
echo "CF_BIN=${CF:-MISSING}"
if [ -n "$CF" ]; then "$CF" --version 2>&1 | head -1; fi

echo "--- 4. login state (cert.pem) ---"
if [ -f "$HOME/.cloudflared/cert.pem" ]; then CERT=yes; echo "CERT=YES"; else CERT=no; echo "CERT=NO"; fi
ls "$HOME/.cloudflared/" 2>/dev/null | head -8

echo "--- 5. existing tunnel config ---"
if [ -f "$HOME/.cloudflared/config.yml" ]; then
  CFG=yes; echo "CONFIG=YES"
  grep -vE '^[[:space:]]*(#|$)' "$HOME/.cloudflared/config.yml" | head -20
else
  CFG=no; echo "CONFIG=NO"
fi

echo "--- 6. tunnels in account ---"
if [ -n "$CF" ] && [ "$CERT" = yes ]; then
  timeout 30 "$CF" tunnel list 2>&1 | head -8
else
  echo "SKIP_no_login"
fi

echo "--- 7. running now ---"
pgrep -af cloudflared 2>/dev/null | head -3 | cut -c1-110
pgrep -af llama-server 2>/dev/null | head -2 | cut -c1-110

echo "--- 8. start-llama.sh invocation ---"
grep -E 'llama-server|--api-key|-t [0-9]' "$HOME/models/start-llama.sh" 2>/dev/null | head -5

echo "--- 9. local ports ---"
for p in 11434 11435 3080 3200; do
  C=$(curl -s -m 3 -o /dev/null -w '%{http_code}' "http://127.0.0.1:$p/" 2>/dev/null || echo 000)
  echo "port $p -> $C"
done

echo "--- VERDICT ---"
echo "V_APIKEY=$AK"
echo "V_CERT=$CERT"
echo "V_CONFIG=$CFG"
echo "TUNNEL-V1-END"
} 2>&1 | tee "$LOG"
