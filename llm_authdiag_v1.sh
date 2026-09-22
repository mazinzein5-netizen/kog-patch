#!/data/data/com.termux/files/usr/bin/bash
set -u
OUT="$HOME/auth_diag.log"
P=11435
KEYF="$HOME/.llm_api_key"
SL="$HOME/models/start-llama.sh"
say() { printf '%s\n' "$*" | tee -a "$OUT"; }
: > "$OUT"
say "AUTH-DIAG-START"
KEY=$(cat "$KEYF" 2>/dev/null || true)
say "1_keylen=${#KEY}"
say "2_file_flag=$(grep -c -- '--api-key-file' "$SL" 2>/dev/null || echo 0)"
FL=$(grep -o -- '-c 2048[^>]*' "$SL" 2>/dev/null | head -1 || true)
say "3_file_line=${FL}"
PROC=$(pgrep -af llama-server 2>/dev/null | head -1 || true)
PF=$(printf '%s' "$PROC" | grep -c -- '--api-key-file' || echo 0)
say "4_proc_has_flag=${PF}"
say "5_proc_count=$(pgrep -c -f llama-server 2>/dev/null || echo 0)"
say "6_proc_cmd=$(printf '%s' "$PROC" | cut -c1-240)"
H="Authorization: Bearer $KEY"
NA=$(curl -s -m 15 -o /dev/null -w '%{http_code}' "http://127.0.0.1:$P/v1/models" 2>/dev/null || true)
say "7_local_models_noauth=${NA:-000}"
AU=$(curl -s -m 15 -o /dev/null -w '%{http_code}' -H "$H" "http://127.0.0.1:$P/v1/models" 2>/dev/null || true)
say "8_local_models_auth=${AU:-000}"
CH=$(curl -s -m 60 -o /dev/null -w '%{http_code}' -H 'Content-Type: application/json' -d '{"messages":[{"role":"user","content":"hi"}],"max_tokens":4}' "http://127.0.0.1:$P/v1/chat/completions" 2>/dev/null || true)
say "9_local_chat_noauth=${CH:-000}"
HP=$(curl -s -m 15 -o /dev/null -w '%{http_code}' "http://127.0.0.1:$P/health" 2>/dev/null || true)
say "10_local_health=${HP:-000}"
VV=$(cat "$HOME/models/llama-server.log" 2>/dev/null | grep -ci 'api.key' || echo 0)
say "11_log_api_key_mentions=${VV}"
say "AUTH-DIAG-END"
