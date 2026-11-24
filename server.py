#!/usr/bin/env python3
import datetime, functools, http.server, importlib.util, json, os, sqlite3, urllib.parse

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DOCS_DIR = os.path.join(BASE_DIR, "docs")
DB_PATH = os.path.join(BASE_DIR, "emon_mainframe.db")

def load_mod(name, rel_path):
    spec = importlib.util.spec_from_file_location(name, os.path.join(BASE_DIR, rel_path))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod

motior = load_mod("motior", "divisions/motior-pharma/telemetry_engine.py")
guardian = load_mod("guardian", "divisions/29a-cyber-guardian/guardian_audit.py")
esec = load_mod("esec", "divisions/esecurity/soc_analyzer.py")

def init_db():
    conn = sqlite3.connect(DB_PATH)
    conn.execute("CREATE TABLE IF NOT EXISTS quotes (id INTEGER PRIMARY KEY AUTOINCREMENT, pages INTEGER, mode TEXT, total_bdt INTEGER, created_at TEXT)")
    conn.execute("CREATE TABLE IF NOT EXISTS inquiries (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, message TEXT, created_at TEXT)")
    conn.execute("CREATE TABLE IF NOT EXISTS observations (id INTEGER PRIMARY KEY AUTOINCREMENT, temp_c REAL, spo2 INTEGER, bpm INTEGER, status TEXT, created_at TEXT)")
    conn.commit()
    conn.close()

class EmonHandler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass

    def _json(self, code, payload):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_OPTIONS(self):
        self.send_response(204)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_GET(self):
        p = urllib.parse.urlparse(self.path).path
        if p == "/api/health":
            return self._json(200, {"status": "ONLINE", "db": "SQLite3", "divisions": 9})
        if p in ("/api/telemetry", "/fhir/Observation"):
            obs = motior.evaluate_clinical(motior.read_sensor())
            s = obs["sensorSource"]
            conn = sqlite3.connect(DB_PATH)
            cur = conn.execute("INSERT INTO observations(temp_c,spo2,bpm,status,created_at) VALUES(?,?,?,?,?)",
                               (s["temp_c"], s["spo2"], s["bpm"], obs["clinicalStatus"], obs["effectiveDateTime"]))
            conn.commit()
            obs["id"] = str(cur.lastrowid)
            conn.close()
            return self._json(200, obs)
        if p == "/api/scan":
            res = guardian.run_integrity_audit(BASE_DIR)
            res["socSummary"] = esec.analyze_logs()
            return self._json(200, res)
        if p == "/api/inquiries":
            conn = sqlite3.connect(DB_PATH)
            rows = conn.execute("SELECT id,name,email,message,created_at FROM inquiries ORDER BY id DESC LIMIT 25").fetchall()
            conn.close()
            return self._json(200, [dict(zip(["id", "name", "email", "message", "created_at"], r)) for r in rows])
        return super().do_GET()

    def do_POST(self):
        p = urllib.parse.urlparse(self.path).path
        n = int(self.headers.get("Content-Length", "0"))
        try:
            data = json.loads(self.rfile.read(n) or b"{}")
        except Exception:
            return self._json(400, {"error": "invalid_json"})

        now = datetime.datetime.now(datetime.timezone.utc).isoformat()
        if p == "/api/quote":
            pages = max(1, int(data.get("pages", 1)))
            mode = "color" if str(data.get("mode", "bw")).lower() == "color" else "bw"
            total = pages * (5 if mode == "color" else 2)
            conn = sqlite3.connect(DB_PATH)
            cur = conn.execute("INSERT INTO quotes(pages,mode,total_bdt,created_at) VALUES(?,?,?,?)", (pages, mode, total, now))
            conn.commit()
            oid = cur.lastrowid
            conn.close()
            return self._json(200, {"order_id": oid, "pages": pages, "mode": mode, "total_bdt": total})

        if p == "/api/inquiries":
            name = str(data.get("name", "")).strip()
            email = str(data.get("email", "")).strip()
            msg = str(data.get("message", "")).strip()
            conn = sqlite3.connect(DB_PATH)
            cur = conn.execute("INSERT INTO inquiries(name,email,message,created_at) VALUES(?,?,?,?)", (name, email, msg, now))
            conn.commit()
            tid = cur.lastrowid
            conn.close()
            return self._json(200, {"ticket_id": tid, "name": name, "status": "LOGGED"})

        return self._json(404, {"error": "not_found"})

if __name__ == "__main__":
    init_db()
    handler = functools.partial(EmonHandler, directory=DOCS_DIR)
    srv = http.server.ThreadingHTTPServer(("0.0.0.0", 8080), handler)
    print("[OK] EMON SQLite Mainframe listening on http://127.0.0.1:8080")
    srv.serve_forever()
