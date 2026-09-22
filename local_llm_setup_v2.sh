#!/data/data/com.termux/files/usr/bin/bash
# Local LLM setup + COMPACT benchmark. Safe to re-run. ASCII only.
M="$HOME/models"
R="$HOME/llm_report.txt"
export OLLAMA_KEEP_ALIVE=30m
{ echo "PHONE-LLM-REPORT-START"
  command -v ollama >/dev/null || { echo "FATAL no_ollama"; exit 1; }
  cd "$M" 2>/dev/null || { echo "FATAL no_models_dir"; exit 1; }
  termux-wake-lock 2>/dev/null
  if ! pgrep -f "ollama serve" >/dev/null; then nohup ollama serve > "$HOME/ollama_serve.log" 2>&1 & fi
  for i in 1 2 3 4 5 6 7 8 9 10 11 12; do curl -sf http://127.0.0.1:11434/api/version >/dev/null 2>&1 && break; sleep 2; done
  if ! curl -sf http://127.0.0.1:11434/api/version >/dev/null 2>&1; then echo "FATAL serve_down"; tail -5 "$HOME/ollama_serve.log"; exit 1; fi
  mk () { printf 'FROM ./%s\nPARAMETER num_ctx 2048\nPARAMETER num_thread %s\n' "$2" "$3" > "MF_$1"; ollama create "$1" -f "MF_$1" >/dev/null 2>&1; }
  mk q15     Qwen2.5-1.5B-Instruct-Q4_K_M.gguf 4
  mk q3b_t4  Qwen2.5-3B-Instruct-Q4_K_M.gguf   4
  mk q3b_t5  Qwen2.5-3B-Instruct-Q4_K_M.gguf   5
  mk q3b_t6  Qwen2.5-3B-Instruct-Q4_K_M.gguf   6
  mk q3b_t8  Qwen2.5-3B-Instruct-Q4_K_M.gguf   8
  mk q4b_t5  Qwen3-4B-Q4_K_M.gguf              5
  echo "MODEL_LOAD_FAILED_COUNT=$(ollama list | grep -c 'q3b_t\|q15\|q4b_t5')"
  echo "MODEL THREADS TOK_PER_SEC"
  bench () { O=$(ollama run "$1" "Write two short sentences about green tea." --verbose 2>&1); V=$(echo "$O" | grep -i 'eval rate' | tail -1 | awk '{print $3}'); [ -z "$V" ] && V=na; echo "$1 $2 $V"; }
  bench q15 4
  bench q3b_t4 4
  bench q3b_t5 5
  bench q3b_t6 6
  bench q3b_t8 8
  bench q4b_t5 5
  echo "DISK=$(df -h "$HOME" | tail -1 | awk '{print $4}')"
  echo "SDCARD_MODELS_DIR=$(ls -d "$HOME/storage/shared/Models" 2>/dev/null || echo absent)"
  echo "PHONE-LLM-REPORT-END"
} 2>&1 | tee "$R" | tail -30
