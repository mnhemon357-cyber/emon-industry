#!/usr/bin/env bash
echo "=== EMON INDUSTRY SYSTEM PULSE ==="
echo "User   : $(whoami)"
echo "Date   : $(date)"
echo "Uptime : $(uptime -p)"
echo "Disk   : $(df -h / | awk 'NR==2 {print $4 " free of " $2}')"
