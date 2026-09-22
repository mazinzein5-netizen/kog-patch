#!/data/data/com.termux/files/usr/bin/bash
# Local LLM setup + benchmark for Termux. Safe to re-run. ASCII only.
M="$HOME/models"
L="$HOME/llm_setup.log"
exec > >(tee -a "$L") 2>&1
echo "=== 0. ENV ==="
command -v ollama || { echo "FATAL: ollama not on PATH"; exit 1; }
ls -la "$M" 2>/dev/null || { echo "FATAL: no $M"; exit 1; }
echo "=== 1. WAKE LOCK ==="
termux-wake-lock 2>/dev/null && echo "wake-lock ok" || echo "wake-lock unavailable"
echo "=== 2. SERVE ==="
if pgrep -f "ollama serve" >/dev/null; then echo "already running"; else nohup ollama serve > "$HOME/ollama_serve.log" 2>&1 & echo "started pid $!"; fi
for i in 1 2 3 4 5 6 7 8 9 10; do curl -sf http://127.0.0.1:11434/api/version >/dev/null 2>&1 && break; sleep 2; done
curl -s http://127.0.0.1:11434/api/version; echo
echo "=== 3. BEFORE ==="
ollama list
echo "=== 4. IMPORT (no keep_alive in Modelfile - not a valid param) ==="
cd "$M" || exit 1
imp () {
  n="$1"; f="$2"; c="$3"; t="$4"
  printf 'FROM ./%s\nPARAMETER num_ctx %s\nPARAMETER num_thread %s\n' "$f" "$c" "$t" > "MF_$n"
  echo "-- create $n threads=$t ctx=$c"
  ollama create "$n" -f "MF_$n" 2>&1 | tail -2
}
imp q15    Qwen2.5-1.5B-Instruct-Q4_K_M.gguf 2048 4
imp q3b_t4 Qwen2.5-3B-Instruct-Q4_K_M.gguf   2048 4
imp q3b_t5 Qwen2.5-3B-Instruct-Q4_K_M.gguf   2048 5
imp q3b_t6 Qwen2.5-3B-Instruct-Q4_K_M.gguf   2048 6
imp q3b_t8 Qwen2.5-3B-Instruct-Q4_K_M.gguf   2048 8
imp q4b_t5 Qwen3-4B-Q4_K_M.gguf              2048 5
echo "=== 5. AFTER ==="
ollama list
echo "=== 6. BENCH (raw verbose tail) ==="
bench () {
  echo ""
  echo "##### $1"
  ollama run "$1" --keep-alive 30m "Write two short sentences about green tea." --verbose 2>&1 | tail -14
}
bench q15
bench q3b_t4
bench q3b_t5
bench q3b_t6
bench q3b_t8
bench q4b_t5
echo "=== 7. SIZES + DISK ==="
du -h "$M"/*.gguf 2>/dev/null | sort -h
df -h "$HOME" | tail -1
echo "=== 8. SDCARD MODELS DIR ==="
ls -ld "$HOME/storage/shared/Models" 2>&1
echo "=== DONE. log=$L ==="
termux-wake-unlock 2>/dev/null
