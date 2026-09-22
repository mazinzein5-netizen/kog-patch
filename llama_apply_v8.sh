#!/data/data/com.termux/files/usr/bin/bash
# v8: apply MEASURED optimal thread count (-t 4) to start-llama.sh. ASCII only.
F="$HOME/models/start-llama.sh"
SAFE="$HOME/models/start-llama.sh.bak_pre_v8"
echo "PHONE-LLAMA-V8-START"
[ -f "$F" ] || { echo "FATAL no_start_script_at_$F"; exit 1; }
echo "--- 1. before ---"
B=$(grep -o -- '-t [0-9][0-9]*' "$F" | head -1)
echo "THREADS_BEFORE=$B"
N=$(grep -c -- ' -t 6 ' "$F")
echo "MATCH_COUNT_exact\" -t 6 \"=$N"
if [ "$N" != "1" ]; then
  echo "WARN unexpected_match_count=$N (not applying sed)"
else
  [ -f "$SAFE" ] || cp "$F" "$SAFE"
  echo "BACKUP=$SAFE"
  sed -i 's/ -t 6 / -t 4 /' "$F"
fi
echo "--- 2. after ---"
A=$(grep -o -- '-t [0-9][0-9]*' "$F" | head -1)
echo "THREADS_AFTER=$A"
if [ "$A" = "-t 4" ]; then echo "PATCH=OK"; else echo "PATCH=CHECK_MANUALLY"; fi
echo "--- 3. full llama-server line ---"
grep -n 'llama-server' "$F" | head -3
echo "--- 4. restart and prove it ---"
pkill -f "llama-server" 2>/dev/null
sleep 2
bash "$F" >/dev/null 2>&1
for i in $(seq 1 20); do
  curl -sf -m 2 http://127.0.0.1:11435/health >/dev/null 2>&1 && break
  sleep 2
done
curl -s -m 8 http://127.0.0.1:11435/health -w " health_http=%{http_code}\n"
echo "ACTIVE_MODEL=$(cat "$HOME/models/current-label" 2>/dev/null)"
R=$(curl -s -m 180 http://127.0.0.1:11435/completion -H 'Content-Type: application/json' -d '{"prompt":"Write two short sentences about green tea.","n_predict":96,"temperature":0.7,"cache_prompt":false}')
V=$(echo "$R" | grep -o '"predicted_per_second":[0-9.]*' | head -1 | cut -d: -f2)
echo "LIVE_AFTER_PATCH_gen_tps=$V"
echo "PHONE-LLAMA-V8-END"
