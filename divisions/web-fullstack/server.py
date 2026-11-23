#!/usr/bin/env python3
"""EMON INDUSTRY PVT LTD — Full-Stack Web & SQLite REST API Server"""
import json
import os
import socket
import sqlite3
from datetime import datetime
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(BASE_DIR, "emon_mainframe.db")
INDEX_PATH = os.path.join(BASE_DIR, "index.html")

def init_db():
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS inquiries (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                email TEXT NOT NULL,
                message TEXT,
                created_at TEXT NOT NULL
            )
        """)
        conn.execute("""
            CREATE TABLE IF NOT EXISTS print_quotes (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                pages INTEGER NOT NULL,
                mode TEXT NOT NULL,
                total_bdt REAL NOT NULL,
                created_at TEXT NOT NULL
            )
        """)

class EmonHandler(BaseHTTPRequestHandler):
    def _send_json(self, payload: dict, status: int = 200):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/" or self.path == "/index.html":
            with open(INDEX_PATH, "rb") as f:
                content = f.read()
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Content-Length", str(len(content)))
            self.end_headers()
            self.wfile.write(content)
        elif self.path == "/api/status":
            self._send_json({
                "company": "EMON INDUSTRY PVT LTD",
                "status": "ONLINE",
                "divisions": 9,
                "timestamp": datetime.now().isoformat()
            })
        elif self.path == "/api/scan":
            open_ports = []
            for p in [22, 80, 443, 8000, 8080]:
                with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                    s.settimeout(0.2)
                    if s.connect_ex(("127.0.0.1", p)) == 0:
                        open_ports.append(p)
            self._send_json({
                "agency": "29A Cyber Guardian",
                "target": "127.0.0.1",
                "open_ports": open_ports,
                "timestamp": datetime.now().isoformat()
            })
        else:
            self._send_json({"error": "Not found"}, 404)

    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        data = json.loads(self.rfile.read(length).decode("utf-8") or "{}")
        now = datetime.now().isoformat()

        if self.path == "/api/quote":
            pages = max(1, int(data.get("pages", 1)))
            mode = data.get("mode", "bw")
            total = pages * (5 if mode == "color" else 2)
            with sqlite3.connect(DB_PATH) as conn:
                cur = conn.execute(
                    "INSERT INTO print_quotes (pages, mode, total_bdt, created_at) VALUES (?, ?, ?, ?)",
                    (pages, mode, total, now)
                )
                order_id = cur.lastrowid
            self._send_json({"order_id": order_id, "pages": pages, "mode": mode, "total_bdt": total})
        elif self.path == "/api/inquiries":
            name = data.get("name", "Anonymous")
            email = data.get("email", "")
            msg = data.get("message", "")
            with sqlite3.connect(DB_PATH) as conn:
                cur = conn.execute(
                    "INSERT INTO inquiries (name, email, message, created_at) VALUES (?, ?, ?, ?)",
                    (name, email, msg, now)
                )
                ticket_id = cur.lastrowid
            self._send_json({"ticket_id": ticket_id, "status": "SAVED"})
        else:
            self._send_json({"error": "Not found"}, 404)

if __name__ == "__main__":
    init_db()
    server = ThreadingHTTPServer(("127.0.0.1", 8080), EmonHandler)
    print("[EMON FULL-STACK] Live at http://127.0.0.1:8080 (Press CTRL+C to stop)")
    server.serve_forever()
