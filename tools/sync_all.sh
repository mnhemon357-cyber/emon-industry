#!/usr/bin/env bash
set -e

REPO_DIR="$HOME/emon-industry"
PHONE_DIR="/sdcard/EMON INDUSTRY PVT LTD"
COMMIT_MSG="${1:-Update EMON INDUSTRY Mainframe}"

echo "=== [1/4] FIXING SSH CONFIG & KEYS ==="
if [ -f /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf ]; then
    sudo mv /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf.bak
    echo "[OK] Fixed broken SSH proxy config."
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
    ssh-keygen -t ed25519 -C "md.emon@emonindustry.com" -f "$HOME/.ssh/id_ed25519" -N ""
fi
ssh-keyscan -H github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null

echo ""
echo "=== [2/4] GITHUB SETUP & PUSH ==="
cd "$REPO_DIR"
git branch -M main

CURRENT_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [ -z "$CURRENT_URL" ] || echo "$CURRENT_URL" | grep -q "YOUR_GITHUB_USERNAME"; then
    echo "Copy this SSH Public Key to GitHub -> Settings -> SSH and GPG keys:"
    echo "------------------------------------------------------------------"
    cat "$HOME/.ssh/id_ed25519.pub"
    echo "------------------------------------------------------------------"
    read -p "Enter your exact GitHub username: " GH_USER
    NEW_URL="git@github.com:${GH_USER}/emon-industry.git"
    if [ -z "$CURRENT_URL" ]; then
        git remote add origin "$NEW_URL"
    else
        git remote set-url origin "$NEW_URL"
    fi
    echo "[!] Ensure you added the SSH key above and created an empty repo named 'emon-industry' on GitHub."
    read -p "Press ENTER when ready to push..." _
fi

git add .
if ! git diff --cached --quiet; then
    git commit -m "$COMMIT_MSG"
fi
git push -u origin main
echo "[OK] Pushed to GitHub successfully."

echo ""
echo "=== [3/4] SYNCING TO PHONE INTERNAL STORAGE ==="
mkdir -p "$PHONE_DIR"
rm -rf "$PHONE_DIR/divisions/eprinter/venv"
tar --exclude='venv' --exclude='.git' --exclude='__pycache__' -cf - -C "$REPO_DIR" . | \
    tar --no-same-owner --no-same-permissions -xf - -C "$PHONE_DIR/"
echo "[OK] Synced clean files to: $PHONE_DIR"

echo ""
echo "=== [4/4] COMPLETE ==="
ls -la "$PHONE_DIR"
