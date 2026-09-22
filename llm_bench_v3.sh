#!/data/data/com.termux/files/usr/bin/bash
# v3: benchmark EXISTING working models via HTTP API (no ollama create). ASCII only.
export OLLAMA_KEEP_ALIVE=30m
tee_out="$HOME/llm_bench_v3.log"
{
echo "PHONE-LLM-V3-START"
command -v ollama >/dev/null || { echo "FATAL no_ollama"; exit 1; }
termux-wake-lock 2>/dev/null
if ! pgrep -f "ollama serve" >/dev/null; then nohup ollama serve > "$HOME/ollama_serve.log" 2>&1 & fi
for i in $(seq 1 15); do curl -sf http://127.0.0.1:11434/api/version >/dev/null 2>&1 && break; sleep 2; done
if ! curl -sf http://127.0.0.1:11434/api/version >/dev/null 2>&1; then echo "FATAL serve_down"; tail -5 "$HOME/ollama_serve.log"; exit 1; fi
echo "VERSION=$(curl -s http://127.0.0.1:11434/api/version)"
echo "EXISTING_MODELS:"
ollama list
echo "--- BENCH (runtime num_thread via API) ---"
bench () {
  M="$1"; T="$2"
  R=$(curl -s -m 300 http://127.0.0.1:11434/api/generate -H 'Content-Type: application/json' -d "{\"model\":\"$M\",\"prompt\":\"Write two short sentences about green tea.\",\"stream\":false,\"options\":{\"num_thread\":$T,\"num_ctx\":2048,\"num_predict\":128}}")
  EC=$(echo "$R" | grep -o '"eval_count":[0-9]*' | head -1 | cut -d: -f2)
  ED=$(echo "$R" | grep -o '"eval_duration":[0-9]*' | head -1 | cut -d: -f2)
  if [ -n "$EC" ] && [ -n "$ED" ] && [ "$ED" != "0" ]; then
    TPS=$(awk -v c="$EC" -v d="$ED" 'BEGIN{printf "%.2f", c/(d/1000000000)}')
  else
    TPS="FAIL"; ERR=$(echo "$R" | grep -o '"error":"[^"]*"' | head -1)
  fi
  echo "$M threads=$T tok_per_s=$TPS $ERR"
}
bench qwen2.5:1.5b 4
bench qwen2.5:1.5b 5
bench qwen2.5:1.5b 6
bench qwen2.5:1.5b 8
bench qwen3:4b 4
bench qwen3:4b 5
bench qwen3:4b 6
bench qwen3:4b 8
echo "--- GGUF MAGIC (expect 47475546 = GGUF) ---"
for f in "$HOME"/models/*.gguf; do [ -e "$f" ] || continue; printf '%s ' "$(basename "$f")"; head -c 4 "$f" | od -An -tx1 | tr -d ' \n'; echo; done
rm -f "$HOME"/models/MF_* "$HOME"/models/MF1 "$HOME"/models/MF2 "$HOME"/models/MF3 2>/dev/null
echo "PHONE-LLM-V3-END"
} 2>&1 | tee "$tee_out" | tail -35
