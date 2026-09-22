#!/data/data/com.termux/files/usr/bin/bash
# v7: FAST llama.cpp thread check, LIVE streaming output. ASCII only.
P="$PREFIX/lib/ollama"
S="$P/llama-server"
[ -x "$S" ] || S="$P/llama-server"
M="$HOME/models"
export LD_LIBRARY_PATH="$P"
echo "PHONE-LLAMA-V7-START"
if [ ! -x "$S" ]; then echo "FATAL no_server_bin"; exit 1; fi
echo "SERVER=$S"
G="$M/Qwen2.5-3B-Instruct-Q4_K_M.gguf"
[ -f "$G" ] || { echo "FATAL no_3b_model"; exit 1; }
termux-wake-lock 2>/dev/null
pkill -f "ollama serve" 2>/dev/null
sleep 2
run () {
  T="$1"
  pkill -f "llama-server" 2>/dev/null
  sleep 3
  "$S" -m "$G" --port 11435 --host 127.0.0.1 --no-webui \
    -c 2048 -np 1 --jinja -b 256 -ub 256 -t "$T" \
    --flash-attn auto -ctk q8_0 -ctv q8_0 > "$M/llama_v7_srv.log" 2>&1 &
  ok=0
  for i in $(seq 1 45); do
    if curl -sf -m 2 http://127.0.0.1:11435/health >/dev/null 2>&1; then ok=1; break; fi
    sleep 1
  done
  if [ "$ok" != 1 ]; then
    echo "thr=$T LOAD_FAIL"; tail -3 "$M/llama_v7_srv.log"; return
  fi
  R=$(curl -s -m 240 http://127.0.0.1:11435/completion -H 'Content-Type: application/json' \
      -d '{"prompt":"Write two short sentences about green tea.","n_predict":96,"temperature":0.7,"cache_prompt":false}')
  V=$(echo "$R" | grep -o '"predicted_per_second":[0-9.]*' | head -1 | cut -d: -f2)
  if [ -z "$V" ]; then echo "thr=$T GEN_FAIL"; else echo "RESULT thr=$T gen_tps=$V"; fi
}
echo "--- 1. warmup t=5 (ignore this number) ---"
run 5
echo "--- 2. t=5 repeat ---"
run 5
echo "--- 3. t=4 ---"
run 4
echo "--- 4. t=6 ---"
run 6
pkill -f "llama-server" 2>/dev/null
echo "THERMAL_MAX=$(for z in /sys/class/thermal/thermal_zone*/temp; do [ -r "$z" ] && cat "$z"; done | sort -n | tail -1)"
echo "PHONE-LLAMA-V7-END"
