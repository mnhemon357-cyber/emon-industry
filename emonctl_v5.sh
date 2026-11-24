#!/usr/bin/env bash
# EMON INDUSTRY maintenance controller
# Safe for Termux and Kali/NetHunter. Does not install packages or delete project data.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORT="${EMON_PORT:-9000}"
HOST="${EMON_HOST:-127.0.0.1}"
URL="http://${HOST}:${PORT}/"
LOG="$ROOT/logs/web.log"
PIDFILE="$ROOT/logs/web.pid"
BACKUP_DIR="$ROOT/backup"

say(){ printf '%s\n' "$*"; }
have(){ command -v "$1" >/dev/null 2>&1; }

http_ok() {
  if have curl; then
    curl -fsS --max-time 3 "$URL" >/dev/null 2>&1
  else
    python3 -c 'import sys,urllib.request; urllib.request.urlopen(sys.argv[1],timeout=3).read(1)' "$URL" >/dev/null 2>&1
  fi
}

pid_is_our_server() {
  local p="$1" args
  kill -0 "$p" 2>/dev/null || return 1
  args="$(ps -p "$p" -o args= 2>/dev/null || true)"
  case "$args" in
    *http.server*"$PORT"*) return 0 ;;
    *http.server*) return 0 ;;
    *) return 1 ;;
  esac
}

start_server() {
  if [ ! -f "$ROOT/docs/index.html" ]; then
    say "[FAIL] Missing docs/index.html; refusing to start."
    return 1
  fi
  mkdir -p "$ROOT/logs"
  if http_ok; then
    say "[ONLINE] An HTTP server already answers at $URL"
    say "[INFO] Reusing it; no duplicate process started."
    return 0
  fi
  if [ -f "$PIDFILE" ]; then
    oldpid="$(cat "$PIDFILE" 2>/dev/null || true)"
    if [ -n "$oldpid" ] && pid_is_our_server "$oldpid"; then
      say "[INFO] Recorded server process exists but HTTP check failed."
      say "[INFO] Leaving it untouched; inspect $LOG before recovery."
      return 1
    fi
    rm -f "$PIDFILE"
  fi

  nohup python3 -m http.server "$PORT" \
    --bind "$HOST" --directory "$ROOT/docs" \
    >"$LOG" 2>&1 </dev/null &
  newpid=$!
  printf '%s\n' "$newpid" > "$PIDFILE"
  sleep 2
  if http_ok; then
    say "[PASS] Dashboard online: $URL (PID $newpid)"
    return 0
  fi
  say "[FAIL] Server did not become healthy. Log follows:"
  cat "$LOG" 2>/dev/null || true
  return 1
}

stop_server() {
  if [ ! -f "$PIDFILE" ]; then
    say "[INFO] No controller PID file. Nothing was stopped."
    say "[INFO] A server on port $PORT may belong to another launcher."
    return 0
  fi
  p="$(cat "$PIDFILE" 2>/dev/null || true)"
  if [ -n "$p" ] && pid_is_our_server "$p"; then
    kill "$p" 2>/dev/null || true
    sleep 1
    kill -0 "$p" 2>/dev/null && kill -TERM "$p" 2>/dev/null || true
    say "[STOP] Sent stop signal to controller process $p."
  else
    say "[INFO] PID file is stale or process identity did not match; not killing anything."
  fi
  rm -f "$PIDFILE"
}

status() {
  say "=== EMON INDUSTRY STATUS ==="
  say "Project: $ROOT"
  say "Python: $(python3 --version 2>&1 || echo unavailable)"
  if http_ok; then say "[PASS] HTTP $URL"; else say "[FAIL] HTTP $URL"; fi
  if [ -f "$ROOT/docs/index.html" ]; then say "[PASS] docs/index.html"; else say "[FAIL] docs/index.html missing"; fi
  if [ -f "$ROOT/docs/sw.js" ]; then say "[PASS] docs/sw.js"; else say "[WARN] docs/sw.js missing"; fi
  if [ -d "$ROOT/.github/workflows" ]; then
    say "[PASS] GitHub workflow directory"
    find "$ROOT/.github/workflows" -maxdepth 1 -type f -print 2>/dev/null
  else
    say "[WARN] No .github/workflows directory in this local project"
  fi
  if [ -d "$ROOT/divisions/eapk-mobile" ]; then
    say "[INFO] Android project directory exists"
    find "$ROOT/divisions/eapk-mobile" -maxdepth 4 \
      \( -name gradlew -o -name settings.gradle -o -name settings.gradle.kts \
         -o -name build.gradle -o -name build.gradle.kts -o -name AndroidManifest.xml \) \
      -print 2>/dev/null
  else
    say "[WARN] divisions/eapk-mobile not found"
  fi
}

doctor() {
  local failed=0
  say "=== EMON INDUSTRY DOCTOR ==="
  for c in bash python3; do
    if have "$c"; then say "[PASS] $c: $(command -v "$c")"; else say "[FAIL] Missing $c"; failed=1; fi
  done
  for f in docs/index.html launch.sh stop.sh; do
    if [ -f "$ROOT/$f" ]; then say "[PASS] $f"; else say "[WARN] $f missing"; fi
  done
  if python3 - "$ROOT/docs/index.html" <<'PY'
import sys
from html.parser import HTMLParser
from pathlib import Path
class Check(HTMLParser):
    pass
p=Path(sys.argv[1])
try:
    Check().feed(p.read_text(encoding="utf-8"))
    print("[PASS] HTML parser")
except Exception as e:
    print("[FAIL] HTML parser:", e)
    raise SystemExit(1)
PY
  then :; else failed=1; fi

  if [ -d "$ROOT/divisions/eapk-mobile" ]; then
    if find "$ROOT/divisions/eapk-mobile" -maxdepth 5 -name gradlew -type f -print -quit | grep -q .; then
      say "[PASS] Gradle wrapper found"
    else
      say "[WARN] No gradlew found: this directory may be WebView assets, not a buildable Gradle app."
    fi
  else
    say "[WARN] Android project folder missing"
  fi
  if [ "$failed" -eq 0 ]; then say "[DONE] Basic checks complete."; fi
  return "$failed"
}

backup() {
  mkdir -p "$BACKUP_DIR"
  stamp="$(date +%Y%m%d-%H%M%S)"
  out="$BACKUP_DIR/emon-industry-$stamp.tar.gz"
  if have tar; then
    tar -czf "$out" \
      --exclude='./backup' --exclude='./logs/*.log' \
      -C "$ROOT" .
    say "[BACKUP] Created $out"
  else
    say "[FAIL] tar is unavailable; no backup created."
    return 1
  fi
}

case "${1:-help}" in
  start) start_server ;;
  stop) stop_server ;;
  restart) stop_server; start_server ;;
  status) status ;;
  doctor|check) doctor ;;
  backup) backup ;;
  all)
    doctor
    status
    backup
    ;;
  help|*)
    cat <<USAGE
EMON INDUSTRY controller
Run from the project directory:
  ./emonctl.sh start    Start or reuse healthy dashboard
  ./emonctl.sh stop     Stop only the process recorded by this controller
  ./emonctl.sh restart  Stop recorded process, then start
  ./emonctl.sh status   Show server, workflow and Android project status
  ./emonctl.sh doctor   Check local files and HTML
  ./emonctl.sh backup   Create a timestamped project backup
  ./emonctl.sh all      Doctor + status + backup
Optional port override: EMON_PORT=9001 ./emonctl.sh start
USAGE
    ;;
esac
