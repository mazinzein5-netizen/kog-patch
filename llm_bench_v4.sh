#!/data/data/com.termux/files/usr/bin/bash
# v4: confirm optimal threads with cool-downs + thermal evidence. ASCII only.
export OLLAMA_KEEP_ALIVE=30m
{
echo "PHONE-LLM-V4-START"
command -v ollama >/dev/null || { echo FATAL_no_ollama; exit 1; }
termux-wake-lock 2>/dev/null
if ! pgrep -f "ollama serve" >/dev/null; then nohup ollama serve > "$HOME/ollama_serve.log" 2>&1 & fi
for i in $(seq 1 15); do curl -sf http://127.0.0.1:11434/api/version >/dev/null 2>&1 && break; sleep 2; done
curl -sf http://127.0.0.1:11434/api/version >/dev/null 2>&1 || { echo FATAL_serve_down; tail -5 "$HOME/ollama_serve.log"; exit 1; }
echo "VER=$(curl -s http://127.0.0.1:11434/api/version)"
gen () {
  M="$1"; T="$2"
  R=$(curl -s -m 300 http://127.0.0.1:11434/api/generate -H 'Content-Type: application/json' -d "{\"model\":\"$M\",\"prompt\":\"Write two short sentences about green tea.\",\"stream\":false,\"options\":{\"num_thread\":$T,\"num_ctx\":2048,\"num_predict\":128}}")
  EC=$(echo "$R" | grep -o '"eval_count":[0-9]*' | head -1 | cut -d: -f2)
  ED=$(echo "$R" | grep -o '"eval_duration":[0-9]*' | head -1 | cut -d: -f2)
  if [ -n "$EC" ] && [ -n "$ED" ] && [ "$ED" != "0" ]; then
    TPS=$(awk -v c="$EC" -v d="$ED" 'BEGIN{printf "%.2f", c/(d/1000000000)}')
  else
    TPS=FAIL
  fi
  echo "$M thr=$T tps=$TPS"
}
vert () { echo "THERMAL: $(for z in /sys/class/thermal/thermal_zone*/temp; do [ -r "$z" ] && cat "$z"; done | sort -n | tail -1)"; }
echo "--- warmup (not counted) ---"
gen qwen2.5:1.5b 4 >/dev/null; sleep 10
echo "--- 1.5B: repeated pairs with 8s cool ---"
for T in 3 4 5 6; do gen qwen2.5:1.5b $T; sleep 8; gen qwen2.5:1.5b $T; sleep 8; done
vert
echo "--- 4B: repeated pairs with 8s cool ---"
for T in 4 5 6; do gen qwen3:4b $T; sleep 8; gen qwen3:4b $T; sleep 8; done
vert
echo "--- bake-params test (create FROM existing model, no GGUF file) ---"
printf 'FROM qwen2.5:1.5b\nPARAMETER num_thread 4\nPARAMETER num_ctx 2048\n' > "$HOME/MF_bake"
ollama create q15f -f "$HOME/MF_bake" 2>&1 | tail -2
if ollama list | grep -q q15f; then echo "BAKE=OK"; else echo "BAKE=FAIL"; fi
echo "PHONE-LLM-V4-END"
} 2>&1 | tee "$HOME/llm_bench_v4.log" | tail -40
