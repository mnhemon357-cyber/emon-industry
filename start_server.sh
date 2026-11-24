#!/usr/bin/env bash
cd "$(dirname "$0")"
mkdir -p logs
if [ -f .emon-server.pid ]; then
    kill "$(cat .emon-server.pid)" 2>/dev/null || true
fi
nohup python3 server.py > logs/server.log 2>&1 &
echo $! > .emon-server.pid
sleep 1
echo "[OK] Local SQLite Server PID $(cat .emon-server.pid) running at http://127.0.0.1:8080"
