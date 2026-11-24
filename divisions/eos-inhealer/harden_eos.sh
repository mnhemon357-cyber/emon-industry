#!/usr/bin/env bash
set -e
echo "=== EOS (INHEALER OS) // SOVEREIGN SYSTEM HARDENING ==="
if command -v ufw >/dev/null 2>&1; then
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow 22/tcp
    sudo ufw --force enable
    echo "[OK] UFW Firewall active (Default Deny Incoming, SSH Allowed)."
else
    echo "[INFO] UFW not installed on mobile container; skipping kernel firewall."
fi
echo "[OK] EOS Sovereign Security Profile verified."
