#!/data/data/com.termux/files/usr/bin/bash
# v6: llama.cpp thread sweep via bundled llama-server (no install). ASCII only.
P="$PREFIX/lib/ollama"
S="$P/lib/llama-server"
M="$HOME/models"
export LD_LIBRARY_PATH="$P"
{
echo "PHONE-LLAMA-V6-START"
if [ ! -x "$S" ]; then S="$P/llama-server"; fi
if [ ! -x "$S" ]; then echo "FATAL server_binary_missing"; ls -la "$P" 2>/dev/null | head -20; echo PHONE-LLAMA-V6-END; exit 1; fi
echo "SERVER=$S"
termux-wake-lock 2>/dev/null
pkill -f "ollama serve" 2>/dev/null
sleep 2
run_once () {
  GGUF="$1"; T="$2"; TAG="$3"
  pkill -f "llama-server" 2>/dev/null
  sleep 3
  nohup "$S" -m "$M/$GGUF" --port 11435 --host 127.0.0.1 --no-webui -c 2048 -np 1 --jinja -b 256 -ub 256 -t "$T" --flash-attn auto -ctk q8_0 -ctv q8_0 > "$M/llama_v6.log" 2>&1 < /dev/null &
  ok=0
  for i in $(seq 1 40); do
    if curl -sf -m 3 http://127.0.0.1:11435/health >/dev/null 2>&1; then ok=1; break; fi
    sleep 1
  done
  if [ "$ok" != "1" ]; then echo "$TAG thr=$T FAIL load"; tail -4 "$M/llama_v6.log"; return; fi
  R=$(curl -s -m 240 http://127.0.0.1:11435/completion -H 'Content-Type: application/json' -d '{"prompt":"Write two short sentences about green tea.","n_predict":128,"temperature":0.7,"cache_prompt":false}')
  V=$(echo "$R" | grep -o '"predicted_per_second":[0-9.]*' | head -1 | cut -d: -f2)
  PP=$(echo "$R" | grep -o '"prompt_per_second":[0-9.]*' | head -1 | cut -d: -f2)
  if [ -z "$V" ]; then echo "$TAG thr=$T FAIL gen"; echo "$R" | head -c 200; return; fi
  echo "$TAG thr=$T gen_tps=$V prefill_tps=$PP"
}
vert () { echo "THERMAL_MAX=$(for z in /sys/class/thermal/thermal_zone*/temp; do [ -r "$z" ] && cat "$z"; done | sort -n | tail -1)"; }
echo "--- warmup (uncounted) ---"
run_once "Qwen2.5-1.5B-Instruct-Q4_K_M.gguf" 4 warmup >/dev/null 2>&1
sleep 10
echo "--- 1.5B sweep ---"
for T in 4 5 6; do run_once "Qwen2.5-1.5B-Instruct-Q4_K_M.gguf" "$T" q15; sleep 8; done
vert
echo "--- 3B sweep ---"
for T in 4 5 6; do run_once "Qwen2.5-3B-Instruct-Q4_K_M.gguf" "$T" q3b; sleep 8; done
vert
echo "--- 4B sweep ---"
for T in 4 5; do run_once "Qwen3-4B-Q4_K_M.gguf" "$T" q4b; sleep 8; done
vert
pkill -f "llama-server" 2>/dev/null
echo "SERVER_STOPPED_after_test"
echo "PHONE-LLAMA-V6-END"
} 2>&1 | tee "$HOME/llama_v6.log" | tail -30
