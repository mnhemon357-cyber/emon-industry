#!/data/data/com.termux/files/usr/bin/bash
set -u
ROOT="${EMON_ROOT:-$HOME/emon-industry}"
if [[ -f "$ROOT/logs/web.pid" ]]; then
  kill "$(cat "$ROOT/logs/web.pid")" 2>/dev/null || true
  rm -f "$ROOT/logs/web.pid"
fi
pkill -f "http.server ${EMON_PORT:-9000} --bind 127.0.0.1" 2>/dev/null || true
echo "EMON local website stopped (if it was running)."
