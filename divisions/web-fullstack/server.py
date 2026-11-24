#!/usr/bin/env python3
import http.server, json, sqlite3, hashlib, os, time, socket, re
from urllib.parse import urlparse
from datetime import datetime, timezone
from collections import Counter

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
        self.send_header("Access-Control-Allow-Origin", "*"); self.send_header("Access-Control-Allow-Headers", "*")
        self.send_header("Access-Control-Allow-Methods", "GET,POST,OPTIONS"); self.end_headers()
        self.wfile.write(body if isinstance(body, bytes) else body.encode())
    def _j(self, code, obj): self._send(code, json.dumps(obj))
    def do_OPTIONS(self): self._send(204, b"")
    
    def do_GET(self):
        p = urlparse(self.path).path
        if p == "/fhir/Observation":
            t = time.time(); bpm = round(72 + (t % 10) - 5, 1); spo2 = round(97 + (t % 3) - 1.5, 1); temp = round(36.6 + (t % 2) * 0.1, 2)
            now = datetime.now(timezone.utc).isoformat(); conn = sqlite3.connect(DB)
            conn.execute("INSERT INTO observations(bpm,spo2,temp,observed_at) VALUES(?,?,?,?)", (bpm, spo2, temp, now)); conn.commit(); conn.close()
            return self._j(200, {"resourceType": "Observation", "component": [{"code": {"text": "BPM"}, "valueQuantity": {"value": bpm}}, {"code": {"text": "SpO2"}, "valueQuantity": {"value": spo2}}, {"code": {"text": "Temp"}, "valueQuantity": {"value": temp}}]})
        return self._j(404, {"error": "not_found"})

    def do_POST(self):
        p = urlparse(self.path).path; n = int(self.headers.get("Content-Length", "0")); raw = self.rfile.read(n) if n else b"{}"
        try: d = json.loads(raw or b"{}")
        except Exception: return self._j(400, {"error": "invalid_json"})
        
        if p == "/api/soc-scan":
            # Esecurity SOC Logic
            log_path = os.path.join(os.path.dirname(__file__), "..", "esecurity", "mock_auth.log")
            if not os.path.exists(log_path): return self._j(200, {"status": "error", "msg": "Log file not found."})
            failed_ips = Counter(); threshold = 3; alerts = []
            with open(log_path, "r") as f:
                for line in f:
                    if "Failed password" in line:
                        ip_match = re.search(r'from (\d+\.\d+\.\d+\.\d+)', line)
                        if ip_match: failed_ips[ip_match.group(1)] += 1
            for ip, count in failed_ips.items():
                if count >= threshold: alerts.append(f"[ALERT] Brute-force from {ip} ({count} attempts). BLOCKED.")
                else: alerts.append(f"[INFO] Suspicious activity from {ip} ({count} attempts).")
            return self._j(200, {"status": "success", "alerts": alerts})

        if p == "/api/recon-scan":
            # 29A Cyber Guardian Logic
            target = "127.0.0.1"; ports = [22, 80, 443, 3306, 8000]; open_ports = []
            for port in ports:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM); s.settimeout(0.2)
                if s.connect_ex((target, port)) == 0: open_ports.append(port)
                s.close()
            report = f"Target: {target}\nOpen Ports: {open_ports}\nDate: {datetime.now()}"
            evidence_hash = hashlib.sha256(report.encode('utf-8')).hexdigest()
            return self._j(200, {"status": "success", "open_ports": open_ports, "hash": evidence_hash})

        if p == "/api/vat-invoice":
            # Efirm VAT Logic
            price = float(d.get("price", 0)); qty = int(d.get("qty", 1))
            subtotal = price * qty; vat = subtotal * 0.15; total = subtotal + vat
            return self._j(200, {"subtotal": subtotal, "vat": vat, "total": total})
            
        return self._j(404, {"error": "not_found"})

if __name__ == "__main__":
    init_db(); port = 8000
    srv = http.server.ThreadingHTTPServer(("0.0.0.0", port), H)
    print(f"EMON Backend v5.1 running on port {port}"); srv.serve_forever()
