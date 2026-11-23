#!/usr/bin/env python3
"""EMON (EI) — On-Bound AI Security & Log Triage Engine"""
import json
import os
from datetime import datetime

REPORT_PATH = os.path.expanduser("~/emon-industry/divisions/29a-cyber-guardian/audit_report.json")

RISK_DB = {
    21: ("HIGH", "FTP transmits credentials in plaintext. Replace with SFTP (Port 22)."),
    22: ("MEDIUM", "SSH exposed. Enforce Ed25519 key-only login and disable root password auth."),
    80: ("MEDIUM", "Unencrypted HTTP active. Redirect all traffic to HTTPS (Port 443) via TLS."),
    3306: ("HIGH", "MySQL database port exposed. Bind strictly to 127.0.0.1."),
    8000: ("LOW", "Development web port open (EPrinter/API). Place behind Nginx reverse proxy in production."),
    8080: ("MEDIUM", "Alternate HTTP port open. Verify authentication and firewall rules.")
}

def analyze_scan():
    print("==========================================================")
    print(" EMON (EI) // ON-BOUND AI SECURITY ANALYST")
    print(" EMON INDUSTRY PVT LTD — BEYOND FUTURE")
    print("==========================================================")

    if not os.path.exists(REPORT_PATH):
        print(f"[EI WARNING] No 29A scan found at {REPORT_PATH}. Run scanner_29a.py first.")
        return

    with open(REPORT_PATH, "r") as f:
        scan = json.load(f)

    target = scan.get("target", "Unknown")
    open_ports = scan.get("open_ports", [])
    print(f"Target Audited : {target}")
    print(f"Scan Timestamp : {scan.get('timestamp')}")
    print(f"Open Ports     : {len(open_ports)}\n")

    if not open_ports:
        print("[EI VERDICT] Attack surface clean. Zero exposed common ports detected.")
    else:
        for entry in open_ports:
            port = entry["port"]
            severity, advice = RISK_DB.get(port, ("INFO", "Review service necessity and restrict via UFW firewall."))
            print(f" -> Port {port} [{severity}]: {advice}")

    summary_file = os.path.expanduser("~/emon-industry/divisions/ei-onbound-ai/ei_executive_brief.txt")
    with open(summary_file, "w") as out:
        out.write(f"EMON (EI) SECURITY BRIEF | {datetime.now().isoformat()}\n")
        out.write(f"Target: {target} | Open Ports: {len(open_ports)}\n")
    print(f"\n[EI COMPLETE] Executive brief saved to {summary_file}")

if __name__ == "__main__":
    analyze_scan()
