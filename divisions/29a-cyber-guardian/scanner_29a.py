#!/usr/bin/env python3
import socket, json
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor

COMMON_PORTS = [21, 22, 25, 53, 80, 110, 143, 443, 3306, 8000, 8080]

def scan_port(target: str, port: int):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(0.8)
            if s.connect_ex((target, port)) == 0:
                return {"port": port, "state": "OPEN"}
    except Exception:
        pass
    return None

def audit_target(target: str):
    with ThreadPoolExecutor(max_workers=20) as pool:
        results = [r for r in pool.map(lambda p: scan_port(target, p), COMMON_PORTS) if r]
    report = {
        "agency": "29A Cyber Guardian // EMON INDUSTRY PVT LTD",
        "target": target,
        "timestamp": datetime.now().isoformat(),
        "open_ports": results
    }
    with open("audit_report.json", "w") as f:
        json.dump(report, f, indent=2)
    print(json.dumps(report, indent=2))

if __name__ == "__main__":
    audit_target("127.0.0.1")
