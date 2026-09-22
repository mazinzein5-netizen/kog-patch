#!/data/data/com.termux/files/usr/bin/bash
# v9: patch start-llama.sh thread flag, streaming output, with diagnostics. ASCII only.
F="$HOME/models/start-llama.sh"
BAK="$HOME/models/start-llama.sh.bak_pre_v9"
LOG="$HOME/models/patch_v9.log"
{
echo "PATCH-V9-START"
[ -f "$F" ] || { echo "FATAL no_file_at_$F"; exit 1; }
echo "--- BEFORE: matches of -t <digits> ---"
grep -o -- '-t [0-9][0-9]*' "$F" | head -10
CNT=$(grep -o -- '-t [0-9][0-9]*' "$F" | wc -l | tr -d ' ')
echo "OCCURRENCE_COUNT=$CNT"
if [ "$CNT" -ge 1 ]; then
  [ -f "$BAK" ] || cp "$F" "$BAK"
  if [ -f "$BAK" ]; then echo "BACKUP=yes"; else echo "BACKUP=no"; fi
  sed -i 's/-t 6/-t 4/g' "$F"
  echo "SED_APPLIED"
else
  echo "NO_MATCH_REFUSING"
fi
echo "--- AFTER: matches of -t <digits> ---"
grep -o -- '-t [0-9][0-9]*' "$F" | head -10
V=$(grep -o -- '-t [0-9][0-9]*' "$F" | head -1)
if [ "$V" = "-t 4" ]; then echo "PATCH=OK"; else echo "PATCH=FAIL"; fi
echo "--- exact bytes of the flag line (cat -A) ---"
grep -n -e 'llama-server' "$F" | head -3
sed -n '/-t 6/s/.*/[FAIL] line still contains -t 6/p; /-t 4/s/.*/[OK] line contains -t 4/p' "$F" | head -4
echo "--- restart and prove live ---"
pkill -f 'llama-server' 2>/dev/null
sleep 2
bash "$F" >/dev/null 2>&1
ok=0
for i in $(seq 1 25); do
  if curl -sf -m 2 http://127.0.0.1:11435/health >/dev/null 2>&1; then ok=1; break; fi
  sleep 2
done
if [ "$ok" != "1" ]; then echo "HEALTH_FAIL"; tail -5 "$HOME/models/llama-server.log" 2>/dev/null; else echo "HEALTH=OK"; fi
curl -s -m 8 http://127.0.0.1:11435/health -w " health_http=%{http_code}\n"
echo "ACTIVE_MODEL=$(cat "$HOME/models/current-label" 2>/dev/null)"
R=$(curl -s -m 240 http://127.0.0.1:11435/completion -H 'Content-Type: application/json' -d '{"prompt":"Write two short sentences about green tea.","n_predict":96,"temperature":0.7,"cache_prompt":false}')
V2=$(echo "$R" | grep -o '"predicted_per_second":[0-9.]*' | head -1 | cut -d: -f2)
if [ -n "$V2" ]; then echo "LIVE_gen_tps=$V2"; else echo "LIVE_gen_FAIL"; echo "$R" | head -c 300; fi
echo "PATCH-V9-END"
} 2>&1 | tee "$LOG"
