#!/usr/bin/env bash
set -e

REPO_DIR="$HOME/emon-industry"
PHONE_DIR="/sdcard/EMON INDUSTRY PVT LTD"
COMMIT_MSG="${1:-Deploy Full-Stack Web & Android APK ($(date '+%Y-%m-%d %H:%M'))}"

# Keep Web, GitHub Pages (/docs), and Android APK assets synchronized
if [ -f "$REPO_DIR/divisions/web-fullstack/index.html" ]; then
    cp "$REPO_DIR/divisions/web-fullstack/index.html" "$REPO_DIR/docs/index.html"
    cp "$REPO_DIR/divisions/web-fullstack/index.html" "$REPO_DIR/divisions/eapk-mobile/app/src/main/assets/index.html"
fi

cd "$REPO_DIR"
git branch -M main 2>/dev/null || true
git add .
if ! git diff --cached --quiet 2>/dev/null; then
    git commit -m "$COMMIT_MSG"
fi

mkdir -p "$PHONE_DIR"
rm -rf "$PHONE_DIR/divisions/eprinter/venv"
tar --exclude='venv' --exclude='.git' --exclude='__pycache__' --exclude='*.db' -cf - -C "$REPO_DIR" . | \
    tar --no-same-owner --no-same-permissions -xf - -C "$PHONE_DIR/"
echo "[OK] Mirrored all project files to Internal Storage: $PHONE_DIR"

if git push -u origin main; then
    echo "[OK] Pushed live to GitHub: https://github.com/mnhemon357-cyber/emon-industry"
else
    echo "[WARN] GitHub push skipped (offline). Local storage is up to date."
fi
