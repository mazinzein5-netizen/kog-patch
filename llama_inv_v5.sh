#!/data/data/com.termux/files/usr/bin/bash
# v5: llama.cpp inventory (diagnostic only, fast). ASCII only.
L="$HOME/llama_v5.log"
BIN=""
for b in llama-cli llama-server main server; do
  p=$(command -v "$b" 2>/dev/null)
  if [ -z "$BIN" ] && [ -n "$p" ]; then BIN="$b:$p"; fi
done
if [ -z "$BIN" ]; then
  for b in llama-cli llama-server main server; do
    p=$(ls "$PREFIX"/bin/"$b" 2>/dev/null | head -1)
    if [ -z "$BIN" ] && [ -n "$p" ]; then BIN="$b:$p"; fi
  done
fi
{
echo "PHONE-LLAMA-V5-START"
echo "VERDICT_LLAMA_FOUND=$( [ -n "$BIN" ] && echo yes || echo no )"
echo "VERDICT_LLAMA_BIN=$BIN"
echo "PREFIX=${PREFIX:-unset}"
echo "--- A. on PATH ---"
for b in llama-cli llama-server llama-bench llama-quantize llama-gguf main server; do
  p=$(command -v "$b" 2>/dev/null); [ -n "$p" ] && echo "$b=$p"
done
echo "--- B. PREFIX/bin matching llama ---"
ls "$PREFIX"/bin 2>/dev/null | grep -i llama | head -20
echo "--- B2. ollama bundled runner ---"
ls "$PREFIX"/lib/ollama 2>/dev/null | head -20
echo "--- C. installed pkgs matching llama ---"
pkg list-installed 2>/dev/null | grep -i llama | head -5
echo "--- D. start-llama.sh ---"
head -40 "$HOME/models/start-llama.sh" 2>/dev/null || echo missing
echo "--- E. switch-model.sh ---"
head -30 "$HOME/models/switch-model.sh" 2>/dev/null || echo missing
echo "--- F. state ---"
echo "current-model=$(cat "$HOME/models/current-model" 2>/dev/null)"
echo "current-label=$(cat "$HOME/models/current-label" 2>/dev/null)"
echo "--- G. llama-server.log tail ---"
tail -12 "$HOME/models/llama-server.log" 2>/dev/null || echo missing
echo "PHONE-LLAMA-V5-END"
} 2>&1 | tee "$L" | tail -75
