#!/data/data/com.termux/files/usr/bin/bash
set -e; cd "$HOME/emon-industry"; mkdir -p logs
if [ -f .emon-server.pid ] && kill -0 "$(cat .emon-server.pid)" 2>/dev/null; then echo "Already running"; exit 0; fi
nohup env PORT="${PORT:-9000}" python3 divisions/web-fullstack/server.py >logs/server.log 2>&1 & echo $! >.emon-server.pid
sleep 1; kill -0 "$(cat .emon-server.pid)" 2>/dev/null || { echo 'Server failed; see logs/server.log'; exit 1; }
echo "Open http://127.0.0.1:${PORT:-9000}"
