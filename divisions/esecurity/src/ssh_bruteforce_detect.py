#!/usr/bin/env python3
"""Defensive: flag IPs with many failed SSH logins in an auth.log file."""
import re, sys, collections
PAT = re.compile(r"Failed password for .* from (\d+\.\d+\.\d+\.\d+)")
def scan(path, threshold=5):
    c = collections.Counter()
    with open(path, errors="replace") as f:
        for line in f:
            m = PAT.search(line)
            if m: c[m.group(1)] += 1
    return {ip: n for ip, n in c.items() if n >= threshold}
if __name__ == "__main__":
    for ip, n in sorted(scan(sys.argv[1] if len(sys.argv) > 1 else "/var/log/auth.log").items(), key=lambda x: -x[1]):
        print(f"ALERT {ip} failed_logins={n}")
