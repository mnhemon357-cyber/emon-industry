#!/usr/bin/env python3
import re
from collections import Counter

print("[ESECURITY] SOC Log Analyzer Initialized.")
log_file = "mock_auth.log"
failed_ips = Counter()
threshold = 3

with open(log_file, "r") as f:
    for line in f:
        if "Failed password" in line:
            # Extract IP address using regex
            ip_match = re.search(r'from (\d+\.\d+\.\d+\.\d+)', line)
            if ip_match:
                failed_ips[ip_match.group(1)] += 1

print(f"Scanning {log_file} for brute-force attacks (Threshold: {threshold})...")
for ip, count in failed_ips.items():
    if count >= threshold:
        print(f"[ALERT] Brute-force detected from {ip} ({count} failed attempts).")
        print(f"[ACTION] Blocking IP {ip} via firewall rule...")
    else:
        print(f"[INFO] Suspicious activity from {ip} ({count} attempts). Monitoring.")
print("[ESECURITY] Scan complete.")
