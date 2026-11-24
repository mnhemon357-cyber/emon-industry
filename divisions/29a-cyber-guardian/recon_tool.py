#!/usr/bin/env python3
import socket
import hashlib
import datetime

print("[29A GUARDIAN] Authorized Recon Toolkit Initialized.")
target = "127.0.0.1" # Localhost scan (safe for testing)
ports_to_scan = [22, 80, 443, 3306, 8000]

report = f"=== PENETRATION TEST REPORT ===\nTarget: {target}\nDate: {datetime.datetime.now()}\n\nOpen Ports:\n"
print(f"Scanning {target}...")

for port in ports_to_scan:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(0.5)
    result = s.connect_ex((target, port))
    if result == 0:
        print(f" -> Port {port}: OPEN")
        report += f" - Port {port}: OPEN\n"
    s.close()

# Cryptographic Evidence Chain
report_bytes = report.encode('utf-8')
evidence_hash = hashlib.sha256(report_bytes).hexdigest()
report += f"\nCryptographic Evidence Hash (SHA-256):\n{evidence_hash}\n"

with open("audit_evidence.txt", "w") as f:
    f.write(report)

print(f"Report saved. SHA-256: {evidence_hash[:16]}...")
