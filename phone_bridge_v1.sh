#!/data/data/com.termux/files/usr/bin/bash
# A0 phone bridge v1: read files + run commands over an ephemeral HTTPS tunnel. ASCII only.
D="$HOME/a0bridge"
mkdir -p "$D" || exit 1
termux-wake-lock 2>/dev/null
PY=python
command -v python >/dev/null 2>&1 || PY=python3
command -v "$PY" >/dev/null 2>&1 || { echo "FATAL no_python"; exit 1; }
command -v cloudflared >/dev/null 2>&1 || { echo "FATAL no_cloudflared"; exit 1; }
K=$(tr -dc 'a-f0-9' < /dev/urandom 2>/dev/null | head -c 24)
[ -z "$K" ] && K=$(date +%s%N | sha256sum | head -c 24)
printf '%s' "$K" > "$D/key.txt"
cat > "$D/bridge.py" <<'PY'
import json, os, subprocess
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse, parse_qs, unquote
HOME = os.path.expanduser("~")
KEY = open(os.path.join(HOME, "a0bridge", "key.txt")).read().strip()
DENY = [".ssh", ".netrc", ".config", ".gnupg", ".aws", "id_ed25519", "id_rsa",
        "secrets.env", ".vercel", ".env", ".bash_history", ".git-credentials", "key.txt"]
MAXREAD = 300000
class H(BaseHTTPRequestHandler):
    server_version = "a0bridge/1.0"
    def log_message(self, *a):
        pass
    def _send(self, code, body, ctype="text/plain; charset=utf-8"):
        if isinstance(body, str):
            body = body.encode("utf-8", "replace")
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)
    def _ok(self, q):
        return q.get("k", [""])[0] == KEY
    def do_GET(self):
        u = urlparse(self.path)
        q = parse_qs(u.query)
        if not self._ok(q):
            return self._send(403, "forbidden")
        if u.path == "/health":
            return self._send(200, json.dumps({"ok": True, "home": HOME}), "application/json")
        if u.path == "/ls":
            return self._send(200, self._ls(unquote(q.get("p", [HOME])[0])))
        if u.path == "/read":
            p = unquote(q.get("p", [""])[0])
            if not p:
                return self._send(400, "no path")
            if self._deny(p):
                return self._send(403, "denied")
            try:
                with open(p, "rb") as f:
                    return self._send(200, f.read(MAXREAD).decode("utf-8", "replace"))
            except Exception as e:
                return self._send(500, "read error: " + str(e))
        return self._send(404, "not found")
    def do_POST(self):
        u = urlparse(self.path)
        q = parse_qs(u.query)
        if u.path != "/run":
            return self._send(404, "not found")
        if not self._ok(q):
            return self._send(403, "forbidden")
        n = int(self.headers.get("Content-Length") or 0)
        raw = self.rfile.read(n) if n else b""
        try:
            cmd = json.loads(raw.decode("utf-8", "replace")).get("cmd", "")
        except Exception:
            cmd = raw.decode("utf-8", "replace")
        if not cmd:
            return self._send(400, "no cmd")
        try:
            r = subprocess.run(["bash", "-lc", cmd], capture_output=True, timeout=900)
            out = (r.stdout or b"").decode("utf-8", "replace")[-80000:]
            err = (r.stderr or b"").decode("utf-8", "replace")[-8000:]
            return self._send(200, json.dumps({"rc": r.returncode, "stdout": out, "stderr": err}), "application/json")
        except Exception as e:
            return self._send(500, json.dumps({"rc": -1, "error": str(e)}), "application/json")
    def _deny(self, p):
        low = p.lower()
        return any(d.lower() in low for d in DENY)
    def _ls(self, p):
        if self._deny(p):
            return "denied"
        try:
            r = subprocess.run(["ls", "-la", p], capture_output=True, timeout=30)
            return (r.stdout or b"").decode("utf-8", "replace") + (r.stderr or b"").decode("utf-8", "replace")
        except Exception as e:
            return "ls error: " + str(e)
srv = ThreadingHTTPServer(("127.0.0.1", 8099), H)
srv.serve_forever()
PY
pkill -f "a0bridge/bridge.py" 2>/dev/null
pkill -f "cloudflared tunnel --url http://127.0.0.1:8099" 2>/dev/null
sleep 2
nohup "$PY" "$D/bridge.py" > "$D/bridge.log" 2>&1 &
sleep 4
H=$(curl -s -m 6 "http://127.0.0.1:8099/health?k=$K" -w " local_http=%{http_code}")
echo "LOCAL=$H"
nohup cloudflared tunnel --url http://127.0.0.1:8099 --no-autoupdate > "$D/cf.log" 2>&1 &
U=""
for i in $(seq 1 45); do
  U=$(grep -oE 'https://[a-z0-9-]+\.trycloudflare\.com' "$D/cf.log" 2>/dev/null | head -1)
  [ -n "$U" ] && break
  sleep 2
done
if [ -z "$U" ]; then
  echo "TUNNEL_FAILED"; tail -5 "$D/cf.log"; exit 1
fi
echo "PUBLIC_CHECK=$(curl -s -m 25 "$U/health?k=$K" -w ' http=%{http_code}')"
echo "======= BRIDGE LINE - PASTE THIS BACK ======="
echo "$U/?k=$K"
echo "============================================"
echo "STOP: pkill -f a0bridge/bridge.py; pkill -f 'cloudflared tunnel --url http://127.0.0.1:8099'"
