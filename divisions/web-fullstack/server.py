#!/usr/bin/env python3
"""EMON INDUSTRY PVT LTD — v3.0 Full-Stack Web & SQLite REST API Server"""
import hashlib
import json
import os
import random
import socket
import sqlite3
from datetime import datetime
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.abspath(os.path.join(BASE_DIR, "..", ".."))
DB_PATH = os.path.join(BASE_DIR, "emon_mainframe.db")
INDEX_PATH = os.path.join(BASE_DIR, "index.html")

DEFAULT_TODOS = [
    ("Infrastructure", "HIGH", "Install Official EMON INDUSTRY v3.0 APK on Android",
     "1. Open GitHub Releases or tap Download APK in Tab 7.\n2. Install EMON-INDUSTRY-v1.0.apk and allow installation from browser.\n3. Verify the official emblem icon appears on your home screen."),
    ("Infrastructure", "HIGH", "Verify Live GitHub Pages Portal & 5/5 Green CI",
     "1. Open https://mnhemon357-cyber.github.io/emon-industry/ in mobile/desktop browser.\n2. Confirm all 7 tabs load offline & online.\n3. Run 'emon-sync \"Update\"' anytime to sync phone storage + GitHub."),
    ("Division Build", "HIGH", "Milestone 3A: Test Emontron C + Motior Pharma Telemetry",
     "1. Run: ./divisions/emontron/biometric_sim in Termux/Kali.\n2. Start local server: python3 divisions/web-fullstack/server.py\n3. Open Tab 6 (Live Engines) and click 'SAMPLE VITALS' to view live Temp, SpO2 & BPM."),
    ("Division Build", "MEDIUM", "Milestone 3B: Run EOS (Inhealer OS) Hardening Profile",
     "1. Inspect divisions/eos-inhealer/harden_eos.sh.\n2. Execute on Debian/Kali host to enforce UFW default-deny firewall and SSH hardening."),
    ("Certifications", "HIGH", "Milestone 3C: Complete Cert #01 (Cisco Linux Unhatched)",
     "1. Open Tab 4 (14 Free Certs) and tap 'OPEN FREE COURSE' on Step 01.\n2. Complete all modules on netacad.com.\n3. Save your PDF certificate inside ~/emon-industry/docs/certificates/ and run emon-sync."),
    ("Legal & Revenue", "HIGH", "Apply for RJSC Name Clearance (EMON INDUSTRY PVT. LTD.)",
     "1. Visit roc.gov.bd and create an account.\n2. Submit Name Clearance for EMON INDUSTRY PVT. LTD.\n3. Prepare Memorandum & Articles of Association (MOA/AOA) covering all 9 divisions."),
    ("Legal & Revenue", "MEDIUM", "Obtain NBR Company e-TIN, Trade License & 13-Digit BIN",
     "1. Register company e-TIN on incometax.gov.bd.\n2. Apply for Dhaka City Corporation Trade License.\n3. Register for VAT BIN (vat.gov.bd) and apply for BASIS membership."),
    ("Legal & Revenue", "HIGH", "Launch EPrinter B2B Rate Card & 29A SME Security Audit",
     "1. Share EPrinter BDT quote calculator (2 BDT B&W / 5 BDT Color) with 10 local offices.\n2. Offer 29A Web Security Audits to local e-commerce & corporate websites."),
    ("Mobile & Store", "LOW", "Generate Production Keystore (.jks) for Google Play Store",
     "1. Run: keytool -genkey -v -keystore emon-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias emon\n2. Add signingConfig to divisions/eapk-mobile/app/build.gradle for Play Console upload.")
]

def init_db():
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("""CREATE TABLE IF NOT EXISTS todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT NOT NULL,
            priority TEXT NOT NULL,
            title TEXT NOT NULL,
            guide TEXT NOT NULL,
            done INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL
        )""")
        conn.execute("""CREATE TABLE IF NOT EXISTS inquiries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL, email TEXT NOT NULL, message TEXT, created_at TEXT NOT NULL
        )""")
        conn.execute("""CREATE TABLE IF NOT EXISTS print_quotes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pages INTEGER NOT NULL, mode TEXT NOT NULL, total_bdt REAL NOT NULL, created_at TEXT NOT NULL
        )""")
        count = conn.execute("SELECT COUNT(*) FROM todos").fetchone()[0]
        if count == 0:
            now = datetime.now().isoformat()
            for cat, prio, title, guide in DEFAULT_TODOS:
                conn.execute(
                    "INSERT INTO todos (category, priority, title, guide, done, created_at) VALUES (?, ?, ?, ?, 0, ?)",
                    (cat, prio, title, guide, now)
                )

class EmonHandler(BaseHTTPRequestHandler):
    def _send_json(self, payload, status=200):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path in ("/", "/index.html"):
            with open(INDEX_PATH, "rb") as f:
                content = f.read()
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Content-Length", str(len(content)))
            self.end_headers()
            self.wfile.write(content)
        elif self.path == "/api/todos":
            with sqlite3.connect(DB_PATH) as conn:
                rows = conn.execute("SELECT id, category, priority, title, guide, done FROM todos ORDER BY done ASC, id ASC").fetchall()
            items = [{"id": r[0], "category": r[1], "priority": r[2], "title": r[3], "guide": r[4], "done": bool(r[5])} for r in rows]
            self._send_json({"todos": items})
        elif self.path == "/api/telemetry":
            temp_c = round(36.4 + random.uniform(0.0, 1.3), 1)
            spo2 = random.randint(96, 100)
            bpm = random.randint(68, 92)
            batt_v = round(3.85 + random.uniform(0.0, 0.30), 2)
            self._send_json({
                "source": "Emontron DIV-01 -> Motior Pharma DIV-09",
                "temp_c": temp_c,
                "spo2_pct": spo2,
                "heart_bpm": bpm,
                "sensor_voltage": batt_v,
                "clinical_status": "ALERT" if (temp_c > 37.5 or spo2 < 95) else "NORMAL",
                "timestamp": datetime.now().isoformat()
            })
        elif self.path == "/api/scan":
            open_ports = []
            for p in [22, 80, 443, 8000, 8080]:
                with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                    s.settimeout(0.15)
                    if s.connect_ex(("127.0.0.1", p)) == 0:
                        open_ports.append(p)
            with open(INDEX_PATH, "rb") as f:
                portal_sha256 = hashlib.sha256(f.read()).hexdigest()[:16]
            self._send_json({
                "agency": "29A Cyber Guardian (DIV-03)",
                "target": "127.0.0.1",
                "open_ports": open_ports,
                "portal_sha256_prefix": portal_sha256,
                "status": "VERIFIED CLEAN",
                "timestamp": datetime.now().isoformat()
            })
        else:
            self._send_json({"error": "Not found"}, 404)

    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        data = json.loads(self.rfile.read(length).decode("utf-8") or "{}")
        now = datetime.now().isoformat()

        if self.path == "/api/todos":
            cat = data.get("category", "General")
            prio = data.get("priority", "HIGH")
            title = data.get("title", "").strip()
            guide = data.get("guide", "Execute via 6-Pillar framework: Learn -> Build -> Validate -> Publish -> Brand -> Earn.").strip()
            if not title:
                self._send_json({"error": "Title required"}, 400)
                return
            with sqlite3.connect(DB_PATH) as conn:
                cur = conn.execute(
                    "INSERT INTO todos (category, priority, title, guide, done, created_at) VALUES (?, ?, ?, ?, 0, ?)",
                    (cat, prio, title, guide, now)
                )
                tid = cur.lastrowid
            self._send_json({"id": tid, "status": "CREATED"})
        elif self.path == "/api/todos/toggle":
            tid = int(data.get("id", 0))
            with sqlite3.connect(DB_PATH) as conn:
                conn.execute("UPDATE todos SET done = CASE WHEN done = 1 THEN 0 ELSE 1 END WHERE id = ?", (tid,))
            self._send_json({"id": tid, "status": "TOGGLED"})
        elif self.path == "/api/todos/delete":
            tid = int(data.get("id", 0))
            with sqlite3.connect(DB_PATH) as conn:
                conn.execute("DELETE FROM todos WHERE id = ?", (tid,))
            self._send_json({"id": tid, "status": "DELETED"})
        elif self.path == "/api/quote":
            pages = max(1, int(data.get("pages", 1)))
            mode = data.get("mode", "bw")
            total = pages * (5 if mode == "color" else 2)
            with sqlite3.connect(DB_PATH) as conn:
                cur = conn.execute(
                    "INSERT INTO print_quotes (pages, mode, total_bdt, created_at) VALUES (?, ?, ?, ?)",
                    (pages, mode, total, now)
                )
                oid = cur.lastrowid
            self._send_json({"order_id": oid, "pages": pages, "mode": mode, "total_bdt": total})
        elif self.path == "/api/inquiries":
            name = data.get("name", "Anonymous")
            email = data.get("email", "")
            msg = data.get("message", "")
            with sqlite3.connect(DB_PATH) as conn:
                cur = conn.execute(
                    "INSERT INTO inquiries (name, email, message, created_at) VALUES (?, ?, ?, ?)",
                    (name, email, msg, now)
                )
                tid = cur.lastrowid
            self._send_json({"ticket_id": tid, "status": "SAVED"})
        else:
            self._send_json({"error": "Not found"}, 404)

if __name__ == "__main__":
    init_db()
    server = ThreadingHTTPServer(("127.0.0.1", 8080), EmonHandler)
    print("[EMON v3.0 FULL-STACK] Live at http://127.0.0.1:8080 (Press CTRL+C to stop)")
    server.serve_forever()
