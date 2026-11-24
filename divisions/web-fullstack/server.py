#!/usr/bin/env python3
import http.server, json, sqlite3, os, time, re
from urllib.parse import urlparse
from datetime import datetime, timezone
from collections import Counter

DB = os.path.join(os.path.dirname(os.path.abspath(__file__)), "emon.db")
RATE_LIMIT_WINDOW = 60 # seconds
MAX_REQUESTS = 30      # per IP per window
request_counts = {}

def init_db():
    conn = sqlite3.connect(DB)
    conn.executescript("""
    CREATE TABLE IF NOT EXISTS inquiries(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, message TEXT, created_at TEXT);
    """)
    conn.commit(); conn.close()

class H(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a): pass
    
    def _send(self, code, body, ctype="application/json"):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("X-Frame-Options", "DENY")
        self.send_header("X-XSS-Protection", "1; mode=block")
        self.end_headers()
        self.wfile.write(body if isinstance(body, bytes) else body.encode())

    def _j(self, code, obj): self._send(code, json.dumps(obj))
    def do_OPTIONS(self): self._send(204, b"")

    def _check_rate_limit(self):
        ip = self.client_address[0]
        now = time.time()
        if ip not in request_counts: request_counts[ip] = []
        # Clean old requests
        request_counts[ip] = [t for t in request_counts[ip] if now - t < RATE_LIMIT_WINDOW]
        if len(request_counts[ip]) >= MAX_REQUESTS:
            return False
        request_counts[ip].append(now)
        return True

    def do_GET(self):
        p = urlparse(self.path).path
        if p == "/api/health":
            return self._j(200, {"status": "healthy", "version": "6.1", "timestamp": datetime.now(timezone.utc).isoformat()})
        return self._j(404, {"error": "not_found"})

    def do_POST(self):
        if not self._check_rate_limit():
            return self._j(429, {"error": "Too many requests. Please wait 60 seconds."})
            
        p = urlparse(self.path).path
        n = int(self.headers.get("Content-Length", "0"))
        raw = self.rfile.read(n) if n else b"{}"
        try: d = json.loads(raw or b"{}")
        except Exception: return self._j(400, {"error": "Invalid JSON"})
        
        if p == "/api/vat-invoice":
            try:
                price = max(0.0, float(d.get("price", 0)))
                qty = max(1, int(d.get("qty", 1)))
                subtotal = price * qty; vat = subtotal * 0.15
                return self._j(200, {"subtotal": subtotal, "vat": vat, "total": subtotal + vat})
            except ValueError:
                return self._j(400, {"error": "Invalid number format"})

        if p == "/api/soc-scan":
            log_path = os.path.join(os.path.dirname(__file__), "..", "esecurity", "mock_auth.log")
            if not os.path.exists(log_path): return self._j(200, {"alerts": ["Log file not found."]})
            failed_ips = Counter(); threshold = 3; alerts = []
            with open(log_path, "r") as f:
                for line in f:
                    if "Failed password" in line:
                        ip_match = re.search(r'from (\d+\.\d+\.\d+\.\d+)', line)
                        if ip_match: failed_ips[ip_match.group(1)] += 1
            for ip, count in failed_ips.items():
                if count >= threshold: alerts.append(f"[ALERT] Brute-force from {ip}. BLOCKED.")
                else: alerts.append(f"[INFO] Suspicious activity from {ip}.")
            return self._j(200, {"alerts": alerts})
            
        if p == "/api/inquiries":
            name = str(d.get("name", ""))[:50]
            email = str(d.get("email", ""))[:100]
            msg = str(d.get("message", ""))[:500]
            conn = sqlite3.connect(DB)
            cur = conn.execute("INSERT INTO inquiries(name,email,message,created_at) VALUES(?,?,?,?)", (name, email, msg, datetime.now(timezone.utc).isoformat()))
            conn.commit(); iid = cur.lastrowid; conn.close()
            return self._j(201, {"id": iid, "status": "received"})
            
        return self._j(404, {"error": "not_found"})

if __name__ == "__main__":
    init_db()
    srv = http.server.ThreadingHTTPServer(("127.0.0.1", 8000), H)
    print("EMON Backend v6.1 [Rate-Limited] running on 127.0.0.1:8000")
    srv.serve_forever()
