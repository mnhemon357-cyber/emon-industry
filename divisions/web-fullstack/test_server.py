#!/usr/bin/env python3
import json, urllib.request
BASE = "http://127.0.0.1:8000"
def get(p):
    with urllib.request.urlopen(BASE + p) as r: return json.loads(r.read())
def post(p, b):
    req = urllib.request.Request(BASE + p, data=json.dumps(b).encode(), headers={"Content-Type": "application/json"}, method="POST")
    with urllib.request.urlopen(req) as r: return json.loads(r.read())
def t_quote_get(): assert get("/api/quote")["pricing"]["bw_bdt"] == 2; print("✓ GET /api/quote")
def t_quote_post(): assert post("/api/quote", {"pages": 10, "color": False})["total_bdt"] == 20; print("✓ POST /api/quote")
def t_scan(): assert post("/api/scan", {"filename": "t.pdf", "content": "hello"})["status"] == "clean"; print("✓ POST /api/scan")
def t_inquiry(): assert "id" in post("/api/inquiries", {"name":"T","email":"t@t.com","message":"hi"}); print("✓ POST /api/inquiries")
def t_fhir(): assert get("/fhir/Observation")["resourceType"] == "Observation"; print("✓ GET /fhir/Observation")
if __name__ == "__main__":
    for t in [t_quote_get, t_quote_post, t_scan, t_inquiry, t_fhir]:
        try: t()
        except Exception as e: print(f"✗ {t.__name__}: {e}")
    print("done")
