#!/usr/bin/env bash
set -e

SRC=$(ls -t /sdcard/Download/emon_v5.sh /sdcard/Download/*v5*.sh* /sdcard/Download/*academy*.sh* 2>/dev/null | head -n 1)
if [ -z "$SRC" ] || [ ! -s "$SRC" ]; then
    echo "[ERROR] No v5 script found in /sdcard/Download."
    echo "Download/save the DeepSeek script into your phone Download folder as emon_v5.sh, then re-run."
    exit 1
fi

echo "[OK] Importing $SRC ($(du -h "$SRC" | cut -f1))..."
cp "$SRC" /home/kali/emon-industry/emon_v5.sh
tr -d '\r' < /home/kali/emon-industry/emon_v5.sh > /home/kali/emon-industry/emon_v5.tmp
mv /home/kali/emon-industry/emon_v5.tmp /home/kali/emon-industry/emon_v5.sh
chown kali:kali /home/kali/emon-industry/emon_v5.sh
chmod +x /home/kali/emon-industry/emon_v5.sh

su - kali -c '
cd ~/emon-industry
bash ./emon_v5.sh
if [ -n "$(git status --porcelain)" ]; then
    if [ -f tools/sync_all.sh ]; then
        bash tools/sync_all.sh "Build EMON Academy v5.0 website and Android app"
    else
        git add docs divisions .github *.md 2>/dev/null || true
        git commit -m "Build EMON Academy v5.0 website and Android app"
        git push
    fi
fi
'
