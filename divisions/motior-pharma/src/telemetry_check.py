#!/usr/bin/env python3
"""Validate a body-temperature telemetry packet (system-design seed)."""
import json, sys
def valid(p):
    return {"device","ts","temp_c"} <= p.keys() and 30.0 <= p["temp_c"] <= 43.0
if __name__ == "__main__":
    pkt = json.loads(sys.argv[1]) if len(sys.argv) > 1 else {"device":"mp-01","ts":0,"temp_c":36.8}
    print("OK" if valid(pkt) else "REJECT")
