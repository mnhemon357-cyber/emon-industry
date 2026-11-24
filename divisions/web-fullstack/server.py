#!/usr/bin/env python3
import http.server, json, sqlite3, os, time, re
from urllib.parse import urlparse
from datetime import datetime, timezone
from collections import Counter

DB = os.path.join(os.path.dirname(os.path.abspath(__file__)), "emon.db")
RATE_LIMIT = {}
def init_db():
    conn = sqlite3.connect(DB)
    conn.executescript("CREATE TABLE IF NOT EXISTS inquiries(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, msg TEXT, created_at TEXT);")
    conn.commit(); conn.close()

class H(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a): pass
    def _send(self, code, body, ctype="application/json"):
        self.send_response(code); self.send_header("Content-Type", ctype)
        self.send_header("Access-Control-Allow-Origin", "*"); self.send_header("X-Content-Type-Options", "nosniff")
        self.end_headers(); self.wfile.write(body.encode() if isinstance(body, str) else body)
    def _j(self, code, obj): self._send(code, json.dumps(obj))
    def do_OPTIONS(self): self._send(204, b"")
    
    def _check_rate(self):
        ip = self.client_address[0]; now = time.time()
        if ip not in RATE_LIMIT: RATE_LIMIT[ip] = []
        RATE_LIMIT[ip] = [t for t in RATE_LIMIT[ip] if now - t < 60]
        if len(RATE_LIMIT[ip]) >= 30: return False
        RATE_LIMIT[ip].append(now); return True

    def do_POST(self):
        if not self._check_rate(): return self._j(429, {"error": "Rate limit exceeded"})
        p = urlparse(self.path).path; n = int(self.headers.get("Content-Length", "0"))
        raw = self.rfile.read(n) if n else b"{}"
        try: d = json.loads(raw or b"{}")
        except: return self._j(400, {"error": "Invalid JSON"})
        
        if p == "/api/vat-invoice":
            try:
                price = max(0.0, float(d.get("price", 0))); qty = max(1, int(d.get("qty", 1)))
                sub = price * qty; vat = sub * 0.15
                return self._j(200, {"subtotal": sub, "vat": vat, "total": sub + vat})
            except: return self._j(400, {"error": "Bad Request"})

        if p == "/api/soc-scan":
            log = os.path.join(os.path.dirname(__file__), "..", "esecurity", "mock_auth.log")
            if not os.path.exists(log): return self._j(200, {"alerts": ["Log missing"]})
            fails = Counter(); alerts = []
            with open(log, "r") as f:
                for line in f:
                    if "Failed password" in line:
                        m = re.search(r'from (\d+\.\d+\.\d+\.\d+)', line)
                        if m: fails[m.group(1)] += 1
            for ip, c in fails.items():
                if c >= 3: alerts.append(f"[ALERT] Brute-force from {ip}. BLOCKED.")
                else: alerts.append(f"[INFO] Suspicious activity from {ip}.")
            return self._j(200, {"alerts": alerts})
            
        return self._j(404, {"error": "Not Found"})

if __name__ == "__main__":
    init_db()
    srv = http.server.ThreadingHTTPServer(("127.0.0.1", 8000), H)
    print("EMON Backend running on http://127.0.0.1:8000")
    srv.serve_forever()
