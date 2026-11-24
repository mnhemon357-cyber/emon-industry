#!/data/data/com.termux/files/usr/bin/bash
set -eu

ROOT="$HOME/emon-industry"
PORT=9000
URL="http://127.0.0.1:$PORT/"

cd "$ROOT"
mkdir -p logs

echo "=== EMON INDUSTRY v5.0 ==="

if curl -fsS "$URL" >/dev/null 2>&1; then
    echo "[ONLINE] Existing dashboard detected"
    echo "$URL"
    exit 0
fi

echo "[START] Starting dashboard..."

nohup python3 -m http.server "$PORT" \
  --bind 127.0.0.1 \
  --directory "$ROOT/docs" \
  > "$ROOT/logs/web.log" 2>&1 &

echo $! > "$ROOT/logs/web.pid"
sleep 2

if curl -fsS "$URL" >/dev/null; then
    echo "[SUCCESS] Dashboard online"
else
    echo "[FAILED] Check logs/web.log"
    cat "$ROOT/logs/web.log"
    exit 1
fi
