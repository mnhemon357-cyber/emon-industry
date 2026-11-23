#!/usr/bin/env python3
"""File integrity baseline (SHA-256). Usage: integrity.py baseline|check DIR"""
import hashlib, json, os, sys
def digest(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for b in iter(lambda: f.read(65536), b""): h.update(b)
    return h.hexdigest()
def walk(d):
    return {os.path.join(r, n): digest(os.path.join(r, n)) for r, _, fs in os.walk(d) for n in fs}
if __name__ == "__main__":
    mode, d = sys.argv[1], sys.argv[2]
    if mode == "baseline":
        json.dump(walk(d), open("baseline.json", "w"), indent=2); print("baseline saved")
    else:
        old, new = json.load(open("baseline.json")), walk(d)
        for p in sorted(set(old) | set(new)):
            if old.get(p) != new.get(p): print("CHANGED", p)
