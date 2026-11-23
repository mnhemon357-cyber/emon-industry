#!/usr/bin/env bash
# Read-only Linux hardening audit
set -u
chk(){ if eval "$2" >/dev/null 2>&1; then echo "PASS  $1"; else echo "FAIL  $1"; fi; }
chk "SSH root login disabled"   "grep -Eqi '^PermitRootLogin\s+no' /etc/ssh/sshd_config"
chk "SSH password auth disabled" "grep -Eqi '^PasswordAuthentication\s+no' /etc/ssh/sshd_config"
chk "ASLR enabled"              "[ \"\$(cat /proc/sys/kernel/randomize_va_space)\" = 2 ]"
chk "Firewall active (ufw/nft)" "command -v ufw >/dev/null && ufw status | grep -q active || nft list ruleset | grep -q chain"
chk "No world-writable /etc files" "[ -z \"\$(find /etc -xdev -type f -perm -0002 2>/dev/null | head -1)\" ]"
