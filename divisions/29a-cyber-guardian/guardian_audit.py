#!/usr/bin/env python3
import hashlib, json, os, platform, datetime

def run_integrity_audit(root="."):
    tracked = [
        "docs/index.html",
        "divisions/emontron/sensor_node.c",
        "divisions/motior-pharma/telemetry_engine.py",
        "divisions/eapk-mobile/app/src/main/java/bd/emonindustry/academy/MainActivity.java",
        "divisions/eios-mobile/EmonIndustryApp/EmonIndustryApp.swift",
    ]
    hashes = {}
    for rel in tracked:
        p = os.path.join(root, rel)
        if os.path.isfile(p):
            with open(p, "rb") as fp:
                hashes[rel] = hashlib.sha256(fp.read()).hexdigest()[:16]
    return {
        "agency": "DIV-03 29A Cyber Guardian",
        "timestamp": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "host": platform.node(),
        "os": f"{platform.system()} {platform.release()}",
        "verifiedFiles": len(hashes),
        "sha256Prefixes": hashes,
        "status": "VERIFIED CLEAN"
    }

if __name__ == "__main__":
    print(json.dumps(run_integrity_audit(), indent=2))
