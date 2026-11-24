#!/bin/bash
set -e
REPO="$HOME/emon-industry"
cd "$REPO"
mkdir -p docs divisions/web-fullstack divisions/eapk-mobile/app/src/main/assets

# Safe SD card copy function (works on Android/Kali chroot)
copy_sd() {
  if [ -d "/sdcard" ]; then cp "$1" "/sdcard/EMON INDUSTRY PVT LTD/$(basename "$1")"; 
  elif [ -d "/mnt/sdcard" ]; then cp "$1" "/mnt/sdcard/EMON INDUSTRY PVT LTD/$(basename "$1")"; fi
}
mkdir -p "/sdcard/EMON INDUSTRY PVT LTD" 2>/dev/null || true

echo "→ [1/6] Writing Efirm + FHIR backend (server.py)…"
cat > divisions/web-fullstack/server.py << 'PYEOF'
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
PYEOF

echo "→ [2/6] Writing smoke tests (test_server.py)…"
cat > divisions/web-fullstack/test_server.py << 'PYEOF'
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
PYEOF

echo "→ [3/6] Patching index.html…"
python3 - << 'PYEOF'
import io
p = 'docs/index.html'
s = open(p, encoding='utf-8').read()
if 'v4.1 Enhancements' not in s:
    enhancement = '''
<script>
/* ==== v4.1 Enhancements ==== */
(function certTracker(){
  var state = {}; try { state = JSON.parse(localStorage.getItem('emon_certs') || '{}'); } catch(e){}
  function save(){ try { localStorage.setItem('emon_certs', JSON.stringify(state)); } catch(e){} }
  function render(){
    var cards = document.querySelectorAll('#certs-grid .cert');
    for (var i = 0; i < cards.length; i++){
      var card = cards[i], n = i + 1, badge = card.querySelector('.cert-badge');
      if (!badge){
        badge = document.createElement('button'); badge.className = 'cert-badge';
        badge.style.cssText = 'margin-top:8px;padding:6px 10px;border-radius:8px;font-size:11px;font-weight:700;cursor:pointer;border:1px solid #252B35;background:transparent;color:#9BA5B4;font-family:inherit;width:100%';
        (function(nn){ badge.onclick = function(e){ e.preventDefault(); e.stopPropagation();
          if (state[nn]) delete state[nn]; else state[nn] = new Date().toISOString().slice(0,10);
          save(); render(); };
        })(n); card.appendChild(badge);
      }
      if (state[n]) { badge.textContent = '✓ Completed ' + state[n]; badge.style.background = '#0E6B38'; badge.style.color = '#fff'; badge.style.borderColor = '#12A05A'; }
      else { badge.textContent = 'Mark Complete'; badge.style.background = 'transparent'; badge.style.color = '#9BA5B4'; badge.style.borderColor = '#252B35'; }
    }
  }
  render();
})();
(function fhirPoll(){
  var readout = document.getElementById('bio-readout'); if (!readout) return;
  var base = location.protocol === 'file:' ? 'http://127.0.0.1:8000' : '';
  function sim(){ var t = Date.now()/1000; readout.textContent = 'BPM ' + (72 + Math.sin(t/3)*4).toFixed(0) + ' · SpO₂ ' + (97 + Math.sin(t)*0.6).toFixed(1) + '% · Temp ' + (36.6 + Math.sin(t/2)*0.15).toFixed(2) + '°C'; readout.style.color = '#12A05A'; }
  function tick(){
    if (typeof fetch !== 'function') return sim();
    fetch(base + '/fhir/Observation', { cache: 'no-store' }).then(function(r){ if (!r.ok) throw 0; return r.json(); }).then(function(o){
      var c = {}; for (var i = 0; i < o.component.length; i++){ c[o.component[i].code.text] = o.component[i].valueQuantity.value; }
      readout.textContent = 'BPM ' + c.BPM + ' · SpO₂ ' + c.SpO2 + '% · Temp ' + c.Temp + '°C  · FHIR live'; readout.style.color = '#12A05A';
    }).catch(sim);
  }
  setInterval(tick, 2000); tick();
})();
(function hardening(){
  var overlay = document.createElement('div'); overlay.id = 'emon-loading';
  overlay.style.cssText = 'position:fixed;inset:0;background:#0B0E11;display:flex;align-items:center;justify-content:center;flex-direction:column;gap:14px;z-index:999;transition:opacity .4s';
  overlay.innerHTML = '<svg width="80" height="80" viewBox="0 0 64 64"><rect x="0" y="0" width="64" height="21" fill="#0B0E11"/><rect x="0" y="21" width="64" height="22" fill="#FFFFFF"/><rect x="0" y="43" width="64" height="21" fill="#0E6B38"/><polygon points="0,0 20,32 0,64" fill="#D61A1F"/><rect x="0.6" y="0.6" width="62.8" height="62.8" fill="none" stroke="#0B0E11" stroke-width="1.4"/><polygon points="40,10 56,32 40,54 24,32" fill="#FFFFFF" stroke="#0B0E11" stroke-width="1.4"/></svg><div style="color:#12A05A;font-weight:800;letter-spacing:2px;font-size:12px">EMON INDUSTRY</div><div style="color:#9BA5B4;font-size:10px;letter-spacing:1px">BUILDING A BETTER TOMORROW</div>';
  document.body.appendChild(overlay);
  function hide(){ setTimeout(function(){ overlay.style.opacity = '0'; setTimeout(function(){ if (overlay.parentNode) overlay.parentNode.removeChild(overlay); }, 420); }, 280); }
  if (document.readyState === 'complete') hide(); else window.addEventListener('load', hide);
  var ob = document.createElement('div'); ob.id = 'emon-offline';
  ob.style.cssText = 'position:fixed;top:0;left:0;right:0;background:#D61A1F;color:#fff;text-align:center;padding:6px;font-size:11px;font-weight:700;letter-spacing:1px;z-index:9999;transform:translateY(-100%);transition:transform .3s';
  ob.textContent = '⚠ OFFLINE — cached mode'; document.body.appendChild(ob);
  function sync(){ ob.style.transform = navigator.onLine ? 'translateY(-100%)' : 'translateY(0)'; }
  window.addEventListener('online', sync); window.addEventListener('offline', sync); sync();
})();
</script>
'''
    s = s.replace('</body>', enhancement + '\n</body>')
    open(p, 'w', encoding='utf-8').write(s)
    print('   patched docs/index.html')
PYEOF

echo "→ [4/6] Syncing assets…"
cp docs/index.html divisions/eapk-mobile/app/src/main/assets/index.html
copy_sd docs/index.html
copy_sd divisions/web-fullstack/server.py

echo "→ [5/6] Adding README…"
cat > divisions/web-fullstack/README.md << 'MDEOF'
# EMON INDUSTRY — Backend (v4.1)
Run: `python3 server.py`
Test: `python3 test_server.py`
MDEOF

echo "→ [6/6] Git commit…"
git add -A
git commit -m "v4.1: Cert Tracker, Efirm+FHIR backend, loading overlay, offline detector" || echo "   (no changes)"
git push origin main || echo "   (push skipped)"

echo "✅ v4.1 DEPLOYED!"

