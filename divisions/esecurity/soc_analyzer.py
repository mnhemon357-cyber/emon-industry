#!/usr/bin/env python3
import json, re
from collections import Counter

SAMPLE_LOG = '''
Failed password for root from 185.220.101.4 port 54122 ssh2
Failed password for root from 185.220.101.4 port 54124 ssh2
Failed password for admin from 45.33.32.156 port 39100 ssh2
Accepted publickey for kali from 127.0.0.1 port 51200 ssh2
'''

def analyze_logs(log_text=SAMPLE_LOG):
    failed_ips = re.findall(r"Failed password for \S+ from (\d+\.\d+\.\d+\.\d+)", log_text)
    counts = Counter(failed_ips)
    blocked = [ip for ip, c in counts.items() if c >= 2]
    return {"division": "DIV-02 Esecurity SOC", "failedAttempts": dict(counts), "autoBlockList": blocked}

if __name__ == "__main__":
    print(json.dumps(analyze_logs(), indent=2))
