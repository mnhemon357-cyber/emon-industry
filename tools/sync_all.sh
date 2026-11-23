#!/usr/bin/env bash
set -e

REPO_DIR="$HOME/emon-industry"
PHONE_DIR="/sdcard/EMON INDUSTRY PVT LTD"
MODE="${1:-local}"
COMMIT_MSG="${2:-Update EMON INDUSTRY Mainframe}"

# 1. Fix broken Kali SSH proxy config if present
if [ -f /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf ]; then
    sudo mv /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf.bak 2>/dev/null || true
fi

# 2. Save local Git commit
cd "$REPO_DIR"
git branch -M main 2>/dev/null || true
git add .
if ! git diff --cached --quiet 2>/dev/null; then
    git commit -m "$COMMIT_MSG"
fi

# 3. Copy all project files cleanly to Android Internal Storage
mkdir -p "$PHONE_DIR"
rm -rf "$PHONE_DIR/divisions/eprinter/venv"
tar --exclude='venv' --exclude='.git' --exclude='__pycache__' -cf - -C "$REPO_DIR" . | \
    tar --no-same-owner --no-same-permissions -xf - -C "$PHONE_DIR/"

echo "[OK] All files saved to Internal Storage: $PHONE_DIR"

# 4. Optional GitHub push (run with: bash "/sdcard/EMON INDUSTRY PVT LTD/sync_all.sh" github)
if [ "$MODE" = "github" ]; then
    mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
    [ ! -f "$HOME/.ssh/id_ed25519.pub" ] && ssh-keygen -t ed25519 -C "md.emon@emonindustry.com" -f "$HOME/.ssh/id_ed25519" -N ""
    ssh-keyscan -H github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null

    CURRENT_URL=$(git remote get-url origin 2>/dev/null || echo "")
    if [ -z "$CURRENT_URL" ] || echo "$CURRENT_URL" | grep -q "YOUR_GITHUB_USERNAME"; then
        echo "Add this SSH key to GitHub -> Settings -> SSH and GPG keys:"
        cat "$HOME/.ssh/id_ed25519.pub"
        read -p "Enter your exact GitHub username: " GH_USER
        NEW_URL="git@github.com:${GH_USER}/emon-industry.git"
        [ -z "$CURRENT_URL" ] && git remote add origin "$NEW_URL" || git remote set-url origin "$NEW_URL"
        read -p "Press ENTER once 'emon-industry' repo is created on GitHub..." _
    fi
    git push -u origin main
    echo "[OK] Pushed to GitHub."
fi
