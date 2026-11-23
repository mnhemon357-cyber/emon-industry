from fastapi import FastAPI, UploadFile, File
from fastapi.responses import HTMLResponse
from pypdf import PdfReader
import io

app = FastAPI(title="EPrinter // EMON INDUSTRY PVT LTD")

HTML_UI = """
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>EPrinter | Emon Industry Pvt Ltd</title>
  <style>
    body { background:#0a0f14; color:#e6edf3; font-family:monospace; padding:24px; max-width:520px; margin:auto; }
    h1 { color:#00ffcc; font-size:22px; margin-bottom:4px; }
    .sub { color:#8b949e; font-size:12px; margin-bottom:20px; }
    .card { border:1px solid #00ffcc44; padding:18px; border-radius:8px; background:#111822; }
    input, button { width:100%; margin-top:12px; padding:10px; box-sizing:border-box; font-family:monospace; }
    button { background:#00ffcc; color:#0a0f14; font-weight:bold; border:none; cursor:pointer; }
    #result { margin-top:16px; padding:12px; background:#0a0f14; border-left:3px solid #00ffcc; display:none; }
  </style>
</head>
<body>
  <h1>EPRINTER CLOUD ENGINE</h1>
  <div class="sub">EMON INDUSTRY PVT LTD // BEYOND FUTURE</div>
  <div class="card">
    <label>Select A4 PDF Document:</label>
    <input type="file" id="pdfFile" accept=".pdf">
    <label style="display:flex;align-items:center;gap:8px;margin-top:12px;">
      <input type="checkbox" id="isColor" style="width:auto;margin:0;"> Color Print (5 BDT/page)
    </label>
    <button onclick="getQuote()">CALCULATE PRINT QUOTE</button>
    <div id="result"></div>
  </div>
  <script>
    async function getQuote() {
      const f = document.getElementById('pdfFile').files[0];
      if (!f) { alert('Select a PDF file first.'); return; }
      const color = document.getElementById('isColor').checked;
      const fd = new FormData();
      fd.append('file', f);
      const res = await fetch('/quote?color=' + color, { method: 'POST', body: fd });
      const data = await res.json();
      const box = document.getElementById('result');
      box.style.display = 'block';
      box.innerHTML = `File: ${data.filename}<br>Pages: ${data.pages}<br>Mode: ${data.mode}<br><b>Total: BDT ${data.total_bdt}</b>`;
    }
  </script>
</body>
</html>
"""

@app.get("/", response_class=HTMLResponse)
def home():
    return HTML_UI

@app.post("/quote")
async def quote(file: UploadFile = File(...), color: bool = False):
    reader = PdfReader(io.BytesIO(await file.read()))
    pages = len(reader.pages)
    rate = 5 if color else 2
    return {
        "filename": file.filename,
        "pages": pages,
        "mode": "Color" if color else "Black & White",
        "total_bdt": pages * rate
    }
