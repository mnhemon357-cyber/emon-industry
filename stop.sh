#!/data/data/com.termux/files/usr/bin/bash
cd "$HOME/emon-industry"; if [ -f .emon-server.pid ]; then kill "$(cat .emon-server.pid)" 2>/dev/null || true; rm -f .emon-server.pid; echo Stopped; else echo 'No server PID'; fi
