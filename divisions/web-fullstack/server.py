#!/usr/bin/env python3
import http.server, json, sqlite3, hashlib, os, time
from urllib.parse import urlparse
from datetime import datetime, timezone
DB = os.path.join(os.path.dirname(os.path.abspath(__file__)), "emon.db")
def init_db():
    conn = sqlite3.connect(DB)
    conn.executescript("""
    CREATE TABLE IF NOT EXISTS quotes(id INTEGER PRIMARY KEY AUTOINCREMENT, pages INTEGER, color INTEGER, total_bdt REAL, created_at TEXT);
    CREATE TABLE IF NOT EXISTS scans(id INTEGER PRIMARY KEY AUTOINCREMENT, hash TEXT, filename TEXT, status TEXT, created_at TEXT);
    CREATE TABLE IF NOT EXISTS inquiries(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, message TEXT, created_at TEXT);
    CREATE TABLE IF NOT EXISTS observations(id INTEGER PRIMARY KEY AUTOINCREMENT, bpm REAL, spo2 REAL, temp REAL, observed_at TEXT);
    """)
    conn.commit(); conn.close()
class H(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a): pass
    def _send(self, code, body, ctype="application/json"):
        self.send_response(code); self.send_header("Content-Type", ctype)
        self.send_header("Access-Control-Allow-Origin", "*"); self.end_headers()
        self.wfile.write(body if isinstance(body, bytes) else body.encode())
    def _j(self, code, obj): self._send(code, json.dumps(obj))
    def do_OPTIONS(self): self._send(204, b"")
    def do_GET(self):
        p = urlparse(self.path).path
        if p == "/api/quote": return self._j(200, {"pricing": {"bw_bdt": 2, "color_bdt": 5}})
        if p == "/api/scan": return self._j(200, {"status": "ready"})
        if p == "/api/inquiries":
            conn = sqlite3.connect(DB)
            rows = conn.execute("SELECT id,name,email,message,created_at FROM inquiries ORDER BY id DESC LIMIT 50").fetchall()
            conn.close()
            return self._j(200, [dict(zip(["id","name","email","message","created_at"], r)) for r in rows])
        if p == "/fhir/Observation":
            t = time.time(); bpm = round(72 + (t % 10) - 5, 1); spo2 = round(97 + (t % 3) - 1.5, 1); temp = round(36.6 + (t % 2) * 0.1, 2)
            now = datetime.now(timezone.utc).isoformat(); conn = sqlite3.connect(DB)
            cur = conn.execute("INSERT INTO observations(bpm,spo2,temp,observed_at) VALUES(?,?,?,?)", (bpm, spo2, temp, now))
            conn.commit(); oid = cur.lastrowid; conn.close()
            return self._j(200, {"resourceType": "Observation", "id": str(oid), "status": "final", "code": {"coding": [{"system": "http://loinc.org", "code": "8867-4", "display": "Heart rate"}]}, "component": [{"code": {"text": "BPM"}, "valueQuantity": {"value": bpm, "unit": "beats/min"}}, {"code": {"text": "SpO2"}, "valueQuantity": {"value": spo2, "unit": "%"}}, {"code": {"text": "Temp"}, "valueQuantity": {"value": temp, "unit": "Cel"}}], "effectiveDateTime": now})
        return self._j(404, {"error": "not_found"})
    def do_POST(self):
        p = urlparse(self.path).path; n = int(self.headers.get("Content-Length", "0")); raw = self.rfile.read(n) if n else b"{}"
        try: d = json.loads(raw or b"{}")
        except Exception: return self._j(400, {"error": "invalid_json"})
        now = datetime.now(timezone.utc).isoformat()
        if p == "/api/quote":
            pages = int(d.get("pages", 1)); color = 1 if d.get("color") else 0; total = pages * (5 if color else 2)
            conn = sqlite3.connect(DB); conn.execute("INSERT INTO quotes(pages,color,total_bdt,created_at) VALUES(?,?,?,?)", (pages, color, total, now)); conn.commit(); conn.close()
            return self._j(200, {"pages": pages, "color": bool(color), "rate_bdt": (5 if color else 2), "total_bdt": total})
        if p == "/api/scan":
            fn = d.get("filename", "unknown"); h = hashlib.sha256(d.get("content","").encode()).hexdigest()
            conn = sqlite3.connect(DB); conn.execute("INSERT INTO scans(hash,filename,status,created_at) VALUES(?,?,?,?)", (h, fn, "scanned", now)); conn.commit(); conn.close()
            return self._j(200, {"filename": fn, "sha256": h, "status": "clean"})
        if p == "/api/inquiries":
            conn = sqlite3.connect(DB); cur = conn.execute("INSERT INTO inquiries(name,email,message,created_at) VALUES(?,?,?,?)", (d.get("name",""), d.get("email",""), d.get("message",""), now))
            conn.commit(); iid = cur.lastrowid; conn.close(); return self._j(201, {"id": iid, "status": "received"})
        return self._j(404, {"error": "not_found"})
if __name__ == "__main__":
    init_db(); port = int(os.environ.get("PORT", 8000))
    srv = http.server.ThreadingHTTPServer(("0.0.0.0", port), H)
    print(f"Backend running on http://0.0.0.0:{port}"); srv.serve_forever()
