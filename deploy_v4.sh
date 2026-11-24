#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================
#   EMON INDUSTRY PVT LTD — v4.0 ALL-IN-ONE DEPLOY
#   Run:  bash ~/emon-industry/deploy_v4.sh
# ==============================================================
set -euo pipefail

REPO="$HOME/emon-industry"
SDCARD="/sdcard/EMON INDUSTRY PVT LTD"

if [ ! -d "$REPO/.git" ]; then
  echo "✗ Not a git repo: $REPO"; exit 1
fi
cd "$REPO"

mkdir -p docs "$SDCARD"
mkdir -p divisions/eapk-mobile/app/src/main/assets

echo "→ [1/5] Writing docs/index.html (v4.0)..."
cat > docs/index.html << 'EMON_HTML_EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
<meta name="theme-color" content="#0B0E11">
<title>EMON INDUSTRY PVT LTD · Building a Better Tomorrow</title>
<style>
:root{--black:#0B0E11;--black-2:#14181E;--black-3:#1C2128;--white:#FFF;--green:#0E6B38;--green-2:#12A05A;--crimson:#D61A1F;--crimson-2:#FF3B40;--text:#E8ECF1;--text-dim:#9BA5B4;--border:#252B35;--radius:14px}
*{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth;scroll-padding-top:70px}
body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;background:var(--black);color:var(--text);line-height:1.6;-webkit-font-smoothing:antialiased}
.app-header{position:sticky;top:0;z-index:50;display:flex;align-items:center;justify-content:space-between;padding:10px 16px;background:rgba(11,14,17,.92);backdrop-filter:blur(12px);border-bottom:1px solid var(--border)}
.brand{display:flex;align-items:center;gap:10px}
.emblem{width:36px;height:36px;flex-shrink:0}
.brand-name{font-weight:800;font-size:14px;letter-spacing:1.5px;color:var(--white)}
.brand-tag{font-size:9px;color:var(--text-dim);letter-spacing:.5px}
.nav{display:flex;gap:14px}
.nav a{color:var(--text-dim);text-decoration:none;font-size:12px;font-weight:600;letter-spacing:.5px;transition:color .2s}
.nav a:hover{color:var(--green-2)}
.menu-btn{display:none;background:none;border:1px solid var(--border);color:var(--text);font-size:18px;padding:4px 10px;border-radius:8px;cursor:pointer}
.device-banner{background:linear-gradient(90deg,var(--green),var(--crimson));color:var(--white);padding:6px 14px;font-size:11px;text-align:center;font-weight:600;letter-spacing:.5px}
.hero{position:relative;padding:80px 20px 60px;text-align:center;overflow:hidden}
.hero-glow{position:absolute;inset:0;background:radial-gradient(circle at 50% 0%,rgba(14,107,56,.35),transparent 60%);pointer-events:none}
.hero-title{font-size:clamp(28px,7vw,54px);font-weight:900;letter-spacing:3px;position:relative;z-index:1;color:var(--white)}
.hero-title span{background:linear-gradient(90deg,var(--green-2),var(--crimson-2));-webkit-background-clip:text;background-clip:text;-webkit-text-fill-color:transparent}
.hero-sub{color:var(--text-dim);margin-top:12px;font-size:13px;letter-spacing:1px;position:relative;z-index:1}
.hero-stats{display:flex;justify-content:center;gap:24px;margin-top:30px;flex-wrap:wrap;position:relative;z-index:1}
.stat{text-align:center}
.stat-num{font-size:26px;font-weight:800;color:var(--green-2)}
.stat-label{font-size:10px;color:var(--text-dim);text-transform:uppercase;letter-spacing:1.5px}
.section{padding:60px 16px;max-width:1200px;margin:0 auto}
.section-head{text-align:center;margin-bottom:36px}
.section-head h2{font-size:clamp(22px,5vw,32px);font-weight:800;letter-spacing:1px;color:var(--white)}
.section-head h2::after{content:'';display:block;width:50px;height:3px;background:linear-gradient(90deg,var(--green-2),var(--crimson-2));margin:12px auto 0;border-radius:2px}
.section-head p{color:var(--text-dim);font-size:13px;margin-top:8px}
.search-wrap{padding:0 16px 20px;max-width:800px;margin:0 auto}
.search-bar{position:relative;display:flex}
.search-bar input{flex:1;padding:12px 16px;padding-right:40px;background:var(--black-2);border:1px solid var(--border);border-radius:12px;color:var(--text);font-size:14px;outline:none;transition:border-color .2s;font-family:inherit}
.search-bar input:focus{border-color:var(--green-2)}
.search-bar button{position:absolute;right:8px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--text-dim);font-size:20px;cursor:pointer;padding:4px 8px}
.search-results{margin-top:10px;background:var(--black-2);border:1px solid var(--border);border-radius:12px;max-height:400px;overflow-y:auto;display:none}
.search-results.show{display:block}
.search-result{padding:10px 14px;border-bottom:1px solid var(--border);cursor:pointer;font-size:13px}
.search-result:last-child{border-bottom:none}
.search-result:hover{background:var(--black-3)}
.sr-tag{display:inline-block;font-size:9px;letter-spacing:1px;color:var(--green-2);border:1px solid var(--green);padding:1px 6px;border-radius:4px;margin-right:8px;text-transform:uppercase}
.backup-bar{display:flex;gap:8px;margin-top:10px;align-items:center;flex-wrap:wrap}
.btn{padding:8px 14px;border-radius:10px;font-size:12px;font-weight:600;cursor:pointer;border:none;transition:all .2s;font-family:inherit}
.btn-outline{background:transparent;border:1px solid var(--border);color:var(--text-dim)}
.btn-outline:hover{border-color:var(--green-2);color:var(--green-2)}
.backup-status{font-size:11px;color:var(--green-2)}
.pillars-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:14px}
.pillar{position:relative;padding:20px;background:linear-gradient(135deg,var(--black-2),var(--black-3));border:1px solid var(--border);border-radius:var(--radius);transition:transform .3s,border-color .3s,box-shadow .3s;overflow:hidden}
.pillar::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:var(--c);transform:scaleX(0);transform-origin:left;transition:transform .3s}
.pillar:hover{transform:translateY(-4px);border-color:var(--c);box-shadow:0 8px 24px rgba(14,107,56,.15)}
.pillar:hover::before{transform:scaleX(1)}
.pillar-num{font-size:11px;color:var(--c);font-weight:800;letter-spacing:2px}
.pillar-name{font-size:15px;font-weight:800;margin:6px 0;color:var(--white)}
.pillar-desc{font-size:12px;color:var(--text-dim);line-height:1.5}
.divisions-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:16px}
.div-card{background:linear-gradient(135deg,var(--black-2),var(--black-3));border:1px solid var(--border);border-radius:var(--radius);padding:18px;cursor:pointer;transition:all .3s;position:relative;overflow:hidden}
.div-card:hover{transform:translateY(-4px);border-color:var(--green-2);box-shadow:0 8px 24px rgba(14,107,56,.2)}
.div-card:hover .div-arrow{transform:translateX(4px)}
.div-num{font-size:10px;letter-spacing:2px;color:var(--crimson-2);font-weight:700}
.div-name{font-size:17px;font-weight:800;margin:4px 0;color:var(--white)}
.div-stack{font-size:11px;color:var(--green-2);font-family:ui-monospace,monospace}
.div-desc{font-size:12px;color:var(--text-dim);margin-top:8px;line-height:1.5}
.div-arrow{display:inline-block;margin-top:12px;font-size:12px;color:var(--green-2);font-weight:600;transition:transform .3s}
.sprint-progress{max-width:600px;margin:0 auto 30px;text-align:center}
.progress-bar{height:8px;background:var(--black-3);border-radius:99px;overflow:hidden;margin-bottom:8px}
.progress-fill{height:100%;background:linear-gradient(90deg,var(--green-2),var(--crimson-2));width:0%;transition:width .4s;border-radius:99px}
#sprint-progress-text{font-size:12px;color:var(--text-dim)}
.week{margin-bottom:26px;background:var(--black-2);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden}
.week-head{padding:14px 18px;background:var(--black-3);font-weight:800;font-size:14px;display:flex;justify-content:space-between;align-items:center;cursor:pointer;user-select:none}
.week-head .week-sub{font-size:11px;color:var(--text-dim);font-weight:500}
.week-days{padding:8px 0;display:none}
.week.open .week-days{display:block}
.day-item{display:flex;align-items:flex-start;gap:10px;padding:10px 18px;border-top:1px solid rgba(37,43,53,.5);cursor:pointer;font-size:12px;transition:background .2s}
.day-item:hover{background:var(--black-3)}
.day-item input{margin-top:3px;accent-color:var(--green-2);flex-shrink:0}
.day-num{color:var(--green-2);font-weight:800;font-size:11px;min-width:42px;letter-spacing:.5px}
.day-item.done .day-text{text-decoration:line-through;color:var(--text-dim)}
.certs-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:12px}
.cert{display:block;background:var(--black-2);border:1px solid var(--border);border-radius:12px;padding:14px;text-decoration:none;color:var(--text);transition:all .3s;position:relative}
.cert:hover{border-color:var(--green-2);transform:translateY(-3px)}
.cert-num{font-size:10px;letter-spacing:2px;color:var(--crimson-2);font-weight:800}
.cert-name{font-size:13px;font-weight:700;margin:4px 0;color:var(--white);line-height:1.3;padding-right:20px}
.cert-provider{font-size:11px;color:var(--text-dim)}
.cert-go{position:absolute;top:12px;right:14px;color:var(--green-2);font-size:14px}
.timeline{position:relative;max-width:700px;margin:0 auto;padding-left:28px}
.timeline::before{content:'';position:absolute;left:9px;top:0;bottom:0;width:2px;background:linear-gradient(180deg,var(--green-2),var(--crimson-2))}
.tl-item{position:relative;margin-bottom:22px;background:var(--black-2);border:1px solid var(--border);border-radius:12px;padding:14px 16px}
.tl-item::before{content:'';position:absolute;left:-25px;top:20px;width:12px;height:12px;border-radius:50%;background:var(--green-2);border:2px solid var(--black)}
.tl-num{font-size:10px;letter-spacing:2px;color:var(--crimson-2);font-weight:800}
.tl-title{font-size:14px;font-weight:700;color:var(--white);margin:2px 0 4px}
.tl-desc{font-size:12px;color:var(--text-dim);line-height:1.5}
.arch-wrap{background:var(--black-2);border:1px solid var(--border);border-radius:var(--radius);padding:16px;overflow-x:auto}
#arch-svg{width:100%;height:auto;min-width:500px;display:block}
.telemetry-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:16px}
.tel-card{background:var(--black-2);border:1px solid var(--border);border-radius:var(--radius);padding:14px}
.tel-card.wide{grid-column:1/-1}
.tel-title{font-size:13px;font-weight:700;margin-bottom:10px;color:var(--white)}
.tel-card canvas{width:100%;height:auto;border-radius:8px;background:var(--black-3);display:block}
.tel-readout{font-size:11px;color:var(--green-2);font-family:ui-monospace,monospace;margin-top:8px;letter-spacing:.5px}
.modal{position:fixed;inset:0;background:rgba(0,0,0,.88);z-index:100;display:none;align-items:flex-start;justify-content:center;padding:20px;overflow-y:auto}
.modal.open{display:flex;animation:fadeIn .2s}
@keyframes fadeIn{from{opacity:0}to{opacity:1}}
.modal-content{background:var(--black-2);border:1px solid var(--border);border-radius:16px;max-width:780px;width:100%;padding:24px;position:relative;margin:auto}
.modal-close{position:absolute;top:12px;right:14px;background:none;border:none;color:var(--text-dim);font-size:24px;cursor:pointer;padding:4px 10px;font-family:inherit}
.modal-close:hover{color:var(--crimson-2)}
.modal-head{display:flex;gap:14px;align-items:center;margin-bottom:18px;padding-right:30px}
.modal-num{width:48px;height:48px;border-radius:12px;background:linear-gradient(135deg,var(--green),var(--green-2));display:flex;align-items:center;justify-content:center;font-size:18px;font-weight:900;color:var(--white);flex-shrink:0}
.modal-head h3{font-size:18px;font-weight:800;color:var(--white)}
.modal-stack{font-size:11px;color:var(--green-2);font-family:ui-monospace,monospace}
.tabs{display:flex;gap:4px;border-bottom:1px solid var(--border);margin-bottom:16px;overflow-x:auto}
.tab{padding:8px 14px;font-size:12px;font-weight:600;color:var(--text-dim);cursor:pointer;border:none;background:none;border-bottom:2px solid transparent;transition:all .2s;white-space:nowrap;font-family:inherit}
.tab.active{color:var(--green-2);border-bottom-color:var(--green-2)}
.tab-body{font-size:13px;line-height:1.7;max-height:60vh;overflow-y:auto;padding-right:6px}
.tab-body h4{color:var(--green-2);font-size:12px;margin:14px 0 6px;letter-spacing:1px;text-transform:uppercase}
.tab-body h4:first-child{margin-top:0}
.tab-body p,.tab-body li{color:var(--text);font-size:13px}
.tab-body ul{padding-left:20px;margin:6px 0}
.tab-body a{color:var(--green-2);text-decoration:underline}
.pathway-step{display:flex;gap:12px;padding:12px 0;border-bottom:1px solid var(--border)}
.pathway-step:last-child{border-bottom:none}
.pathway-num{flex-shrink:0;width:32px;height:32px;border-radius:50%;background:var(--black-3);border:1px solid var(--green);display:flex;align-items:center;justify-content:center;font-weight:800;font-size:12px;color:var(--green-2)}
.pathway-title{font-weight:700;color:var(--white);font-size:13px}
.pathway-desc{font-size:12px;color:var(--text-dim);margin-top:2px}
.footer{text-align:center;padding:40px 16px;border-top:1px solid var(--border);margin-top:40px;font-size:12px;color:var(--text-dim)}
.footer-sub{font-size:10px;margin-top:6px;letter-spacing:1px}
@media(max-width:768px){
  .nav{display:none;position:absolute;top:100%;left:0;right:0;background:var(--black-2);border-bottom:1px solid var(--border);flex-direction:column;padding:10px 16px;gap:10px}
  .nav.open{display:flex}
  .menu-btn{display:block}
  .hero{padding:60px 16px 40px}
  .section{padding:40px 14px}
  .modal-content{padding:18px}
  .tab-body{max-height:none;overflow:visible}
}
</style>
</head>
<body>

<header class="app-header">
  <div class="brand">
    <svg class="emblem" viewBox="0 0 64 64" aria-hidden="true">
      <rect x="0" y="0" width="64" height="21" fill="#0B0E11"/>
      <rect x="0" y="21" width="64" height="22" fill="#FFFFFF"/>
      <rect x="0" y="43" width="64" height="21" fill="#0E6B38"/>
      <polygon points="0,0 20,32 0,64" fill="#D61A1F"/>
      <rect x="0.6" y="0.6" width="62.8" height="62.8" fill="none" stroke="#0B0E11" stroke-width="1.4"/>
      <polygon points="40,10 56,32 40,54 24,32" fill="#FFFFFF" stroke="#0B0E11" stroke-width="1.4"/>
      <line x1="40" y1="18" x2="40" y2="46" stroke="#0B0E11" stroke-width="1.4"/>
      <path d="M34,22 Q40,28 34,32 Q40,36 34,42" fill="none" stroke="#0E6B38" stroke-width="1.4"/>
      <path d="M46,22 Q40,28 46,32 Q40,36 46,42" fill="none" stroke="#0E6B38" stroke-width="1.4"/>
      <circle cx="40" cy="24" r="1.5" fill="#0E6B38"/>
      <circle cx="40" cy="40" r="1.5" fill="#0E6B38"/>
    </svg>
    <div class="brand-text">
      <div class="brand-name">EMON INDUSTRY</div>
      <div class="brand-tag">BUILDING A BETTER TOMORROW</div>
    </div>
  </div>
  <nav class="nav" id="main-nav">
    <a href="#pillars">Pillars</a>
    <a href="#divisions">Divisions</a>
    <a href="#sprint">Sprint</a>
    <a href="#certs">Certs</a>
    <a href="#rjsc">RJSC</a>
    <a href="#architecture">Architecture</a>
    <a href="#telemetry">Telemetry</a>
  </nav>
  <button class="menu-btn" aria-label="Menu" onclick="document.getElementById('main-nav').classList.toggle('open')">☰</button>
</header>

<div id="device-banner" class="device-banner" style="display:none"></div>

<section class="hero">
  <div class="hero-glow"></div>
  <h1 class="hero-title">SOVEREIGN <span>INDUSTRY</span></h1>
  <p class="hero-sub">Beyond Future · A Company for Mankind · Vibe with Frequency</p>
  <div class="hero-stats">
    <div class="stat"><div class="stat-num">9</div><div class="stat-label">Divisions</div></div>
    <div class="stat"><div class="stat-num">6</div><div class="stat-label">Pillars</div></div>
    <div class="stat"><div class="stat-num">29</div><div class="stat-label">Day Sprint</div></div>
    <div class="stat"><div class="stat-num">14</div><div class="stat-label">Certifications</div></div>
  </div>
</section>

<section class="search-wrap">
  <div class="search-bar">
    <input id="global-search" type="text" placeholder="Search divisions, sprint days, certifications, pathways…" autocomplete="off">
    <button id="search-clear" aria-label="Clear" onclick="clearSearch()">×</button>
  </div>
  <div id="search-results" class="search-results"></div>
  <div class="backup-bar">
    <button class="btn btn-outline" onclick="exportProgress()">⬇ Export Progress</button>
    <button class="btn btn-outline" onclick="document.getElementById('import-file').click()">⬆ Import Progress</button>
    <input id="import-file" type="file" accept="application/json" style="display:none" onchange="importProgress(event)">
    <span id="backup-status" class="backup-status"></span>
  </div>
</section>

<section id="pillars" class="section">
  <div class="section-head"><h2>The 6 Pillars</h2><p>Every division executes this exact lifecycle.</p></div>
  <div class="pillars-grid" id="pillars-grid"></div>
</section>

<section id="divisions" class="section">
  <div class="section-head"><h2>9 Sovereign Divisions</h2><p>Click any card to open its full blueprint.</p></div>
  <div class="divisions-grid" id="divisions-grid"></div>
</section>

<section id="sprint" class="section">
  <div class="section-head"><h2>29-Day Sovereign Sprint</h2><p>Track your execution — progress saved locally.</p></div>
  <div class="sprint-progress">
    <div class="progress-bar"><div id="sprint-progress-fill" class="progress-fill"></div></div>
    <div id="sprint-progress-text">0 / 29 completed</div>
  </div>
  <div id="sprint-weeks"></div>
</section>

<section id="certs" class="section">
  <div class="section-head"><h2>14 Free Global Certifications</h2><p>Sequenced "what after what" — click to open.</p></div>
  <div class="certs-grid" id="certs-grid"></div>
</section>

<section id="rjsc" class="section">
  <div class="section-head"><h2>RJSC & Global Incorporation</h2><p>From sole proprietor to Bangladesh Ltd. to international holding.</p></div>
  <div class="timeline" id="rjsc-timeline"></div>
</section>

<section id="architecture" class="section">
  <div class="section-head"><h2>System Architecture</h2><p>How the 9 divisions interconnect.</p></div>
  <div class="arch-wrap"><svg id="arch-svg" viewBox="0 0 800 520" xmlns="http://www.w3.org/2000/svg"></svg></div>
</section>

<section id="telemetry" class="section">
  <div class="section-head"><h2>Live Telemetry Visualizations</h2><p>Simulated data — proof of live-dashboard capability.</p></div>
  <div class="telemetry-grid">
    <div class="tel-card">
      <div class="tel-title">🩺 Emontron · Motior Pharma Biometrics</div>
      <canvas id="bio-canvas" width="600" height="220"></canvas>
      <div class="tel-readout" id="bio-readout">BPM -- · SpO₂ --% · Temp --°C</div>
    </div>
    <div class="tel-card">
      <div class="tel-title">🛡 Esecurity · 29A SOC Radar</div>
      <canvas id="radar-canvas" width="600" height="220"></canvas>
      <div class="tel-readout" id="radar-readout">Threats: -- · Blocked: --</div>
    </div>
    <div class="tel-card wide">
      <div class="tel-title">⭐ 6-Pillar Matrix — Division Strength</div>
      <canvas id="pillar-canvas" width="600" height="220"></canvas>
    </div>
  </div>
</section>

<div id="modal" class="modal" onclick="if(event.target===this)closeModal()">
  <div class="modal-content">
    <button class="modal-close" onclick="closeModal()">×</button>
    <div class="modal-head">
      <div class="modal-num" id="modal-num"></div>
      <div>
        <h3 id="modal-title"></h3>
        <p id="modal-stack" class="modal-stack"></p>
      </div>
    </div>
    <div class="tabs" id="modal-tabs"></div>
    <div class="tab-body" id="modal-body"></div>
  </div>
</div>

<footer class="footer">
  <p>© EMON INDUSTRY PVT LTD · Building a Better Tomorrow</p>
  <p class="footer-sub">Beyond Future · A Company for Mankind · Vibe with Frequency</p>
</footer>

<script>
/* ============================================================
   EMON INDUSTRY v4.0 — Data & Logic (zero external deps)
   ============================================================ */
const PILLARS = [
  {num:'01',name:'LEARN',color:'#0E6B38',desc:'Master low-level CS, RFCs, official manuals, and 14 free global certifications.'},
  {num:'02',name:'BUILD',color:'#12A05A',desc:'Write clean, zero-bloat production code in C, Python, Raku, Java, and Shell.'},
  {num:'03',name:'VALIDATE',color:'#D61A1F',desc:'Automated GitHub Actions CI/CD testing, security audits, and zero-defect verification.'},
  {num:'04',name:'PUBLISH',color:'#FF3B40',desc:'Live GitHub Pages portals, signed Android APKs, and public technical documentation.'},
  {num:'05',name:'BRAND',color:'#0E6B38',desc:'Unified corporate identity, executive datasheets, and international trust.'},
  {num:'06',name:'EARN',color:'#12A05A',desc:'Monetize via B2B SaaS, security audits, print logistics, and turnkey hardware contracts.'}
];

const DIVISIONS = [
{id:'emontron',num:'01',name:'Emontron',stack:'C / RTOS / ESP32',path:'divisions/emontron',
 short:'Embedded IoT microcontrollers, biometric sensors, and sovereign hardware.',
 what:'ESP32-based embedded systems that power EMON INDUSTRY\'s biometric, environmental, and industrial IoT product lines. Runs on bare-metal C and FreeRTOS with zero cloud dependency.',
 why:'Imported IoT devices leak data and cannot be trusted with biometric or industrial telemetry. Emontron eliminates foreign vendor dependency, guarantees zero telemetry, and enables on-shore manufacturing. <b>Revenue:</b> B2B hardware sales, OEM sensor contracts, custom integration fees.',
 pillars:{learn:'ESP32 datasheets, MAX30102/DS18B20 protocols, FreeRTOS kernel internals, ARM Cortex memory map.',build:'Bare-metal C firmware sampling sensors, SD-card logging, WiFi streaming to local SQLite.',validate:'GitHub Actions compiles firmware, runs Unity unit tests, validates power draw.',publish:'Release firmware binaries, schematics, and datasheets on GitHub Pages.',brand:'Position as "The Sovereign Hardware Standard of Bangladesh".',earn:'Sell sensor kits and OEM contracts to hospitals, factories, and schools.'},
 certs:[{name:'Cisco NDG Linux Unhatched',url:'https://www.netacad.com/courses/linux-unhatched',provider:'Cisco'},{name:'Harvard CS50',url:'https://www.harvardonline.harvard.edu/course/cs50-introduction-computer-science',provider:'Harvard'}],
 pathway:[{title:'Foundation',desc:'Learn C, basic electronics, ESP32 programming from datasheets.'},{title:'First Prototype',desc:'Build a biometric node logging SpO2, BPM, temperature to SD.'},{title:'Productize',desc:'PCB, enclosure, firmware v1.0 with OTA updates.'},{title:'Enterprise',desc:'Bangladesh assembly line, BSTI certification, hospital sales.'}]},

{id:'esecurity',num:'02',name:'Esecurity',stack:'Raku / Linux / SOC',path:'divisions/esecurity',
 short:'24/7 Security Operations Center, Raku log correlation, firewall perimeter defense.',
 what:'A sovereign Security Operations Center that ingests logs from Linux, Windows, and IoT endpoints, correlates them with Raku regex, and triggers automated incident responses.',
 why:'Enterprises need a SOC that does not route logs through foreign clouds. <b>Revenue:</b> SOC-as-a-service retainers, incident response audits, firewall hardening contracts.',
 pillars:{learn:'Raku grammars, syslog formats, MITRE ATT&CK framework, OWASP Top 10.',build:'Raku-based log ingestion pipeline feeding Elasticsearch-compatible local store.',validate:'Fuzz parsers, red-team against own detection rules, chaos-test alerts.',publish:'Public threat-intel feed + GitHub Pages case studies.',brand:'Trusted by Bangladeshi banks and hospitals for zero-trust compliance.',earn:'$500–$5,000/mo SOC retainers plus IR audits.'},
 certs:[{name:'Cisco Introduction to Cybersecurity',url:'https://www.netacad.com/courses/introduction-to-cybersecurity',provider:'Cisco'},{name:'PortSwigger Web Security Academy',url:'https://portswigger.net/web-security',provider:'PortSwigger'}],
 pathway:[{title:'Foundation',desc:'Learn Linux hardening, syslog, Raku regex.'},{title:'First Detection',desc:'Write 10 Raku correlation rules for brute-force and privilege escalation.'},{title:'SOC v1',desc:'Deploy log pipeline and alerting dashboard.'},{title:'Enterprise',desc:'24/7 staffed SOC, incident retainer contracts.'}]},

{id:'cyber-guardian',num:'03',name:'29A Cyber Guardian',stack:'Python / Kali / Crypto',path:'divisions/29a-cyber-guardian',
 short:'Authorized penetration testing, OWASP audits, SHA-256 cryptographic assurance.',
 what:'Authorized offensive-security services — network pentests, web-app OWASP audits, social engineering tests — delivered under signed RoE with full cryptographic evidence chains.',
 why:'Banks and enterprises need sovereign pentesters, not foreign consultants flying in. <b>Revenue:</b> per-project pentests ($2k–$20k), quarterly security retainer, employee phishing simulations.',
 pillars:{learn:'OSCP syllabus, OWASP WSTG, cryptography (SHA-256, AES, RSA).',build:'Python tooling wrapping nmap, Burp, sqlmap with signed log output.',validate:'Every finding hashes into a Merkle evidence chain; peer-reviewed reports.',publish:'Anonymized CVE writeups on GitHub Pages.',brand:'"The Sovereign Pentesters of Bangladesh."',earn:'Project-based audits + retainer packages.'},
 certs:[{name:'ISC2 Certified in Cybersecurity (CC)',url:'https://www.isc2.org/certifications/cc',provider:'ISC2'},{name:'Cisco Ethical Hacker',url:'https://www.netacad.com/courses/ethical-hacker',provider:'Cisco'},{name:'PortSwigger Web Security Academy',url:'https://portswigger.net/web-security',provider:'PortSwigger'}],
 pathway:[{title:'Foundation',desc:'Learn networking, Linux, and Python automation.'},{title:'First 10 boxes',desc:'Complete 10 HTB / TryHackMe machines end-to-end.'},{title:'Service launch',desc:'Register pentest offering with sample RoE and report template.'},{title:'Enterprise',desc:'Get on BASIS vendor list; serve banks and hospitals.'}]},

{id:'eos-inhealer',num:'04',name:'EOS (Inhealer OS)',stack:'Debian / Kernel / Bash',path:'divisions/eos-inhealer',
 short:'Hardened zero-telemetry Linux OS for developers and cyber defense.',
 what:'A hardened Debian-based distribution compiled from source with telemetry-stripped packages, AppArmor profiles, and a curated cyber-defense toolchain.',
 why:'Standard Ubuntu phones home and bloats. EOS provides a zero-telemetry OS engineers can install and trust. <b>Revenue:</b> enterprise support contracts, OEM preloads, training.',
 pillars:{learn:'Debian live-build, kernel config, AppArmor, systemd internals.',build:'Custom ISO built with live-build; all telemetry daemons removed and replaced.',validate:'Bootable in QEMU via GitHub Actions; CIS benchmark scoring.',publish:'ISO + checksums + installer guide on GitHub Pages.',brand:'"The Zero-Telemetry Operating System."',earn:'Support contracts ($99–$499/year per seat) and OEM preloads.'},
 certs:[{name:'Cisco NDG Linux Unhatched',url:'https://www.netacad.com/courses/linux-unhatched',provider:'Cisco'},{name:'Linux Foundation Free Courses',url:'https://training.linuxfoundation.org/resources/?_sft_content_type=free-course',provider:'Linux Foundation'}],
 pathway:[{title:'Foundation',desc:'Master Debian packaging and kernel compilation.'},{title:'First ISO',desc:'Build bootable ISO with 5 removed telemetry daemons.'},{title:'v1.0',desc:'Add AppArmor profiles, publish checksums.'},{title:'Enterprise',desc:'OEM preloads + support subscriptions.'}]},

{id:'ei-onbound-ai',num:'05',name:'EMON (EI) — On-Bound AI',stack:'Python / Local LLM',path:'divisions/ei-onbound-ai',
 short:'On-bound offline autonomous AI security analyst and local quantized intelligence.',
 what:'A fully offline AI analyst running quantized Llama-family models on-device. Ingests logs, alerts, and network captures to produce human-readable security narratives.',
 why:'No cloud AI can be trusted with classified SOC data. <b>Revenue:</b> licensed AI appliance, custom fine-tunes, on-site AI deployment.',
 pillars:{learn:'LLM quantization (GGUF/GGML), llama.cpp, prompt engineering for security.',build:'Python API wrapping llama.cpp with SQLite long-term memory.',validate:'Benchmark against LogHub and SecRepo datasets.',publish:'Model cards and fine-tune recipes on GitHub Pages.',brand:'"AI that never leaves your building."',earn:'AI appliance ($3k–$15k hardware + software) plus custom fine-tunes.'},
 certs:[{name:'University of Helsinki Elements of AI',url:'https://course.elementsofai.com/',provider:'Helsinki'},{name:'Kaggle Python & Pandas',url:'https://www.kaggle.com/learn/python',provider:'Kaggle'}],
 pathway:[{title:'Foundation',desc:'Learn Python ML basics and llama.cpp.'},{title:'First Model',desc:'Run 4-bit quantized 7B model on a laptop.'},{title:'Security fine-tune',desc:'Fine-tune on labeled SOC logs.'},{title:'Enterprise',desc:'Ship as appliance + license.'}]},

{id:'efirm',num:'06',name:'Efirm',stack:'Java / SQLite / REST',path:'divisions/efirm',
 short:'Custom enterprise ERP, automated BDT/USD VAT invoicing, and B2B software.',
 what:'Full ERP suite — inventory, HR, accounting, invoicing — architected for Bangladesh (BDT VAT, NBR BIN, RJSC) with multi-currency USD support.',
 why:'Local SMEs are forced onto foreign SaaS that mis-handles BDT VAT. <b>Revenue:</b> per-seat SaaS, one-time deployment, customization.',
 pillars:{learn:'Java 17, SQLite tuning, REST design, BD VAT law, NBR e-TIN integration.',build:'Spring-lite (vanilla Java + Jetty) REST service; SQLite backend; PDF invoice generator.',validate:'JUnit suite, Property-based tests, load testing with 1000 concurrent invoices.',publish:'GitHub Pages demo + downloadable installer.',brand:'"Bangladesh\'s Sovereign ERP."',earn:'$10/seat/mo SaaS + $500–$5k implementation.'},
 certs:[{name:'Harvard CS50',url:'https://www.harvardonline.harvard.edu/course/cs50-introduction-computer-science',provider:'Harvard'},{name:'freeCodeCamp Responsive Web Design',url:'https://www.freecodecamp.org/learn/2022/responsive-web-design/',provider:'freeCodeCamp'}],
 pathway:[{title:'Foundation',desc:'Java + SQL fundamentals.'},{title:'First module',desc:'Invoice + VAT calculation engine.'},{title:'Full ERP',desc:'Add inventory, HR, accounting.'},{title:'Enterprise',desc:'Sign up 20 SMEs; convert to SaaS.'}]},

{id:'eapk-mobile',num:'07',name:'EAPK',stack:'Java / Android SDK',path:'divisions/eapk-mobile',
 short:'Native Android apps, WebView + EmonAndroid JS hardware bridges, automated Gradle APK CI.',
 what:'Native Android applications with a WebView host, a hardware-access JavaScript bridge (EmonAndroid), and automated APK generation in GitHub Actions.',
 why:'Enterprises cannot ship unregulated APKs through Play Store; sovereign app distribution matters. <b>Revenue:</b> custom Android apps, Play Store publishing management, white-label builds.',
 pillars:{learn:'Android SDK, Gradle, WebView security, APK signing.',build:'WebView host + JS bridge; compileSdk 34, minSdk 24.',validate:'GitHub Actions builds APK in ~80s; APK-lint on pull requests.',publish:'Signed APKs attached to GitHub Releases.',brand:'"Bangladesh\'s Sovereign App Factory."',earn:'$1k–$8k per custom Android app.'},
 certs:[{name:'Cisco Python Essentials 1',url:'https://www.netacad.com/courses/python-essentials-1',provider:'Cisco'},{name:'freeCodeCamp Responsive Web Design',url:'https://www.freecodecamp.org/learn/2022/responsive-web-design/',provider:'freeCodeCamp'}],
 pathway:[{title:'Foundation',desc:'Java + Android SDK + Gradle.'},{title:'First APK',desc:'Ship a WebView wrapper APK with bridge.'},{title:'CI/CD',desc:'Gradle build in GitHub Actions, signed release.'},{title:'Enterprise',desc:'White-label app offers to SMEs.'}]},

{id:'eprinter',num:'08',name:'EPrinter',stack:'Python / HTML5 / PDF',path:'divisions/eprinter',
 short:'Automated cloud A4 document pricing (2 BDT B&W / 5 BDT Color), PDF pre-flight, print logistics.',
 what:'A web + mobile print-ordering portal. Users upload PDFs; system pre-flights them (page count, color detection), quotes 2 BDT B&W / 5 BDT color per A4, and dispatches to a local print partner.',
 why:'Informal print shops have no digital ordering layer; enterprises need invoice-friendly printing. <b>Revenue:</b> per-page markup, enterprise print contracts, ad revenue on free tier.',
 pillars:{learn:'PDF parsing (pypdf), page-color detection heuristics, Bangladesh payment rails (bKash/Nagad).',build:'Python Flask backend; HTML5 upload UI; PDF pre-flight pipeline.',validate:'Golden-file tests on 100 PDFs; render diff validation.',publish:'Public order portal + print-partner dashboard.',brand:'"Print any PDF in 60 seconds."',earn:'Per-page markup + enterprise print SLA.'},
 certs:[{name:'freeCodeCamp Responsive Web Design',url:'https://www.freecodecamp.org/learn/2022/responsive-web-design/',provider:'freeCodeCamp'},{name:'Cisco Python Essentials 1',url:'https://www.netacad.com/courses/python-essentials-1',provider:'Cisco'}],
 pathway:[{title:'Foundation',desc:'Python + HTML5 + PDF basics.'},{title:'First quote',desc:'PDF upload → instant 2/5 BDT quote.'},{title:'Print partner',desc:'Integrate one Dhaka print shop.'},{title:'Enterprise',desc:'Multi-partner network + invoicing.'}]},

{id:'motior-pharma',num:'09',name:'Motior Pharma',stack:'C / Python / HL7',path:'divisions/motior-pharma',
 short:'Health-tech clinical telemetry dashboards, diagnostic sensors, pharmacy ERP.',
 what:'Health-tech division: bridges Emontron biometrics to clinical dashboards via HL7/FHIR, and provides a pharmacy ERP for inventory, prescriptions, and expiry management.',
 why:'Hospitals need sovereign clinical telemetry that does not send patient data abroad. <b>Revenue:</b> hospital SaaS, sensor bundles, pharmacy ERP licenses.',
 pillars:{learn:'HL7 v2, FHIR R4, HIPAA/GDPR (and BD equivalents), clinical workflow.',build:'Python FHIR server; C firmware bridging from Emontron sensors.',validate:'Synthetic patient data; conformance tests to FHIR R4 core.',publish:'Public dashboard demo, FHIR API docs.',brand:'"Bangladesh\'s First Sovereign Health-Tech Stack."',earn:'$2k–$20k per hospital contract; pharmacy SaaS.'},
 certs:[{name:'IBM SkillsBuild Cybersecurity',url:'https://skillsbuild.org/',provider:'IBM'},{name:'Harvard CS50',url:'https://www.harvardonline.harvard.edu/course/cs50-introduction-computer-science',provider:'Harvard'}],
 pathway:[{title:'Foundation',desc:'Learn HL7/FHIR and clinical workflows.'},{title:'First dashboard',desc:'Render live SpO2/BPM in FHIR UI.'},{title:'Pilot',desc:'Deploy in one Dhaka clinic.'},{title:'Enterprise',desc:'Multi-hospital SaaS.'}]}
];

const SPRINT = [
  {week:1,title:'Week 1 — Core Mainframe & Languages',days:[
    {day:1,text:'Set up Termux, install Git, initialize GitHub repo `emon-industry`'},
    {day:2,text:'Master Linux shell: files, permissions, processes, pipes'},
    {day:3,text:'C fundamentals: pointers, memory, structs, compilation'},
    {day:4,text:'Python fundamentals: data structures, functions, modules'},
    {day:5,text:'Raku basics: regex, grammars, text processing'},
    {day:6,text:'Java fundamentals: classes, inheritance, packaging'},
    {day:7,text:'Build and commit first shell automation script'}
  ]},
  {week:2,title:'Week 2 — Full-Stack Web, APK & Certs 1–4',days:[
    {day:8,text:'Build responsive HTML/CSS dashboard skeleton'},
    {day:9,text:'Add JavaScript interactivity and localStorage persistence'},
    {day:10,text:'Configure GitHub Actions CI/CD pipeline'},
    {day:11,text:'Build first Android APK with Gradle (compileSdk 34)'},
    {day:12,text:'✅ Cert 1 — Cisco NDG Linux Unhatched'},
    {day:13,text:'✅ Cert 2 — Cisco Introduction to Cybersecurity'},
    {day:14,text:'✅ Certs 3–4 — Networking Basics + freeCodeCamp RWD'}
  ]},
  {week:3,title:'Week 3 — EOS, EI AI, Motior Pharma, Certs 5–8 & RJSC',days:[
    {day:15,text:'Compile hardened EOS (Inhealer OS) Debian kernel'},
    {day:16,text:'Implement Esecurity Raku log correlation pipeline'},
    {day:17,text:'Deploy 29A Cyber Guardian pentest toolkit'},
    {day:18,text:'Run offline EI local LLM (llama.cpp, 4-bit quant)'},
    {day:19,text:'Launch Motior Pharma HL7 telemetry dashboard'},
    {day:20,text:'✅ Certs 5–8 — Cisco Python, Kaggle, ISC2 CC, PortSwigger'},
    {day:21,text:'File RJSC name clearance + MOA/AOA draft'}
  ]},
  {week:4,title:'Week 4 — B2B Commercial Launch, Certs 9–14 & Global Scale',days:[
    {day:22,text:'Obtain RJSC Certificate of Incorporation'},
    {day:23,text:'Register NBR e-TIN'},
    {day:24,text:'Secure Trade License and 13-digit BIN/VAT'},
    {day:25,text:'Join BASIS + configure bKash/Stripe merchant'},
    {day:26,text:'✅ Certs 9–11 — Ethical Hacker, LF Free, AWS Cloud'},
    {day:27,text:'✅ Certs 12–14 — Elements of AI, IBM SkillsBuild, CS50'},
    {day:28,text:'Launch B2B SaaS pricing + client outreach'},
    {day:29,text:'Global scale: ERQ banking, Delaware/Singapore holding'}
  ]}
];

const CERTS = [
  {n:1,name:'NDG Linux Unhatched',provider:'Cisco NetAcad',url:'https://www.netacad.com/courses/linux-unhatched'},
  {n:2,name:'Introduction to Cybersecurity',provider:'Cisco NetAcad',url:'https://www.netacad.com/courses/introduction-to-cybersecurity'},
  {n:3,name:'Networking Basics',provider:'Cisco NetAcad',url:'https://www.netacad.com/courses/networking-basics'},
  {n:4,name:'Responsive Web Design',provider:'freeCodeCamp',url:'https://www.freecodecamp.org/learn/2022/responsive-web-design/'},
  {n:5,name:'Python Essentials 1',provider:'Cisco NetAcad',url:'https://www.netacad.com/courses/python-essentials-1'},
  {n:6,name:'Python & Pandas',provider:'Kaggle',url:'https://www.kaggle.com/learn/python'},
  {n:7,name:'Certified in Cybersecurity (CC)',provider:'ISC2',url:'https://www.isc2.org/certifications/cc'},
  {n:8,name:'Web Security Academy',provider:'PortSwigger',url:'https://portswigger.net/web-security'},
  {n:9,name:'Ethical Hacker',provider:'Cisco NetAcad',url:'https://www.netacad.com/courses/ethical-hacker'},
  {n:10,name:'Linux Foundation Free Courses',provider:'Linux Foundation',url:'https://training.linuxfoundation.org/resources/?_sft_content_type=free-course'},
  {n:11,name:'AWS Cloud Practitioner Essentials',provider:'AWS SkillBuilder',url:'https://explore.skillbuilder.aws/learn/course/external/view/elearning/134/aws-cloud-practitioner-essentials'},
  {n:12,name:'Elements of AI',provider:'University of Helsinki',url:'https://course.elementsofai.com/'},
  {n:13,name:'Cybersecurity Fundamentals',provider:'IBM SkillsBuild',url:'https://skillsbuild.org/'},
  {n:14,name:'CS50: Introduction to CS',provider:'Harvard',url:'https://www.harvardonline.harvard.edu/course/cs50-introduction-computer-science'}
];

const RJSC = [
  {n:'01',title:'RJSC Name Clearance',desc:'Reserve the company name at roc.gov.bd.'},
  {n:'02',title:'MOA & AOA Drafting',desc:'Memorandum & Articles of Association covering all 9 divisions.'},
  {n:'03',title:'Certificate of Incorporation',desc:'File with RJSC and receive the incorporation certificate.'},
  {n:'04',title:'NBR e-TIN',desc:'Register at etin.nbr.gov.bd for the corporate tax identity.'},
  {n:'05',title:'Trade License',desc:'Municipal trade license from the local city corporation.'},
  {n:'06',title:'13-digit BIN / VAT',desc:'Register with NBR for BIN and VAT compliance.'},
  {n:'07',title:'BASIS Membership',desc:'Join Bangladesh Association of Software & Information Services.'},
  {n:'08',title:'Banking + ERQ',desc:'Open corporate account and secure USD Export Retention Quota.'},
  {n:'09',title:'Global Holding',desc:'Incorporate Delaware C-Corp or Singapore Pte Ltd for international ops.'}
];

/* ---------- RENDER: PILLARS ---------- */
document.getElementById('pillars-grid').innerHTML = PILLARS.map(p=>`
  <div class="pillar" style="--c:${p.color}">
    <div class="pillar-num">PILLAR ${p.num}</div>
    <div class="pillar-name">${p.name}</div>
    <div class="pillar-desc">${p.desc}</div>
  </div>`).join('');

/* ---------- RENDER: DIVISIONS ---------- */
document.getElementById('divisions-grid').innerHTML = DIVISIONS.map(d=>`
  <div class="div-card" onclick="openDivision('${d.id}')">
    <div class="div-num">DIV-${d.num}</div>
    <div class="div-name">${d.name}</div>
    <div class="div-stack">${d.stack}</div>
    <div class="div-desc">${d.short}</div>
    <div class="div-arrow">Open blueprint →</div>
  </div>`).join('');

/* ---------- RENDER: SPRINT ---------- */
const sprintState = JSON.parse(localStorage.getItem('emon_sprint')||'{}');
document.getElementById('sprint-weeks').innerHTML = SPRINT.map(w=>`
  <div class="week ${w.week===1?'open':''}">
    <div class="week-head" onclick="this.parentElement.classList.toggle('open')">
      <span>${w.title}</span><span class="week-sub">${w.days.length} days</span>
    </div>
    <div class="week-days">
      ${w.days.map(d=>`
        <label class="day-item ${sprintState[d.day]?'done':''}" data-day="${d.day}">
          <input type="checkbox" ${sprintState[d.day]?'checked':''} onchange="toggleDay(${d.day},this)">
          <span class="day-num">DAY ${String(d.day).padStart(2,'0')}</span>
          <span class="day-text">${d.text}</span>
        </label>`).join('')}
    </div>
  </div>`).join('');
updateSprintProgress();

function toggleDay(day,cb){
  sprintState[day]=cb.checked;
  localStorage.setItem('emon_sprint',JSON.stringify(sprintState));
  cb.closest('.day-item').classList.toggle('done',cb.checked);
  updateSprintProgress();
}
function updateSprintProgress(){
  const done=Object.values(sprintState).filter(Boolean).length;
  document.getElementById('sprint-progress-fill').style.width=(done/29*100)+'%';
  document.getElementById('sprint-progress-text').textContent=`${done} / 29 completed`;
}

/* ---------- RENDER: CERTS ---------- */
document.getElementById('certs-grid').innerHTML = CERTS.map(c=>`
  <a class="cert" href="${c.url}" target="_blank" rel="noopener">
    <div class="cert-go">↗</div>
    <div class="cert-num">CERT ${String(c.n).padStart(2,'0')}</div>
    <div class="cert-name">${c.name}</div>
    <div class="cert-provider">${c.provider}</div>
  </a>`).join('');

/* ---------- RENDER: RJSC ---------- */
document.getElementById('rjsc-timeline').innerHTML = RJSC.map(r=>`
  <div class="tl-item">
    <div class="tl-num">STEP ${r.n}</div>
    <div class="tl-title">${r.title}</div>
    <div class="tl-desc">${r.desc}</div>
  </div>`).join('');

/* ---------- DIVISION MODAL ---------- */
let activeDiv=null;
function openDivision(id){
  const d=DIVISIONS.find(x=>x.id===id);
  if(!d)return;
  activeDiv=d;
  document.getElementById('modal-num').textContent='DIV-'+d.num;
  document.getElementById('modal-title').textContent=d.name;
  document.getElementById('modal-stack').textContent=d.stack+'  ·  '+d.path;
  const tabs=['A · What','B · Why & Revenue','C · Pillars','D · Certs','E · Pathway'];
  document.getElementById('modal-tabs').innerHTML=tabs.map((t,i)=>
    `<button class="tab ${i===0?'active':''}" onclick="selectTab(${i},this)">${t}</button>`).join('');
  renderTab(0);
  document.getElementById('modal').classList.add('open');
}
function selectTab(i,btn){
  document.querySelectorAll('#modal-tabs .tab').forEach(t=>t.classList.remove('active'));
  btn.classList.add('active');
  renderTab(i);
}
function renderTab(i){
  const d=activeDiv;let html='';
  if(i===0){html=`<h4>What It Is</h4><p>${d.what}</p>`;}
  else if(i===1){html=`<h4>Why It Exists & Revenue Model</h4><p>${d.why}</p>`;}
  else if(i===2){
    html='<h4>Execution Across All 6 Pillars</h4>';
    Object.keys(d.pillars).forEach(k=>{html+=`<p><b style="color:var(--crimson-2);text-transform:uppercase">${k}</b> — ${d.pillars[k]}</p>`;});
  }
  else if(i===3){
    html='<h4>Free Division Certifications</h4><ul>';
    d.certs.forEach(c=>{html+=`<li><a href="${c.url}" target="_blank" rel="noopener">${c.name}</a> <span style="color:var(--text-dim)">— ${c.provider}</span></li>`;});
    html+='</ul>';
  }
  else if(i===4){
    html='<h4>4-Stage Zero-to-Enterprise Pathway</h4>';
    d.pathway.forEach((p,idx)=>{html+=`<div class="pathway-step"><div class="pathway-num">${idx+1}</div><div><div class="pathway-title">${p.title}</div><div class="pathway-desc">${p.desc}</div></div></div>`;});
  }
  document.getElementById('modal-body').innerHTML=html;
}
function closeModal(){document.getElementById('modal').classList.remove('open');}

/* ---------- GLOBAL SEARCH ---------- */
const searchIndex=[];
DIVISIONS.forEach(d=>{
  searchIndex.push({tag:'DIV',label:`${d.name} — ${d.short}`,action:()=>openDivision(d.id)});
  d.certs.forEach(c=>searchIndex.push({tag:'CERT',label:`${d.name} · ${c.name}`,action:()=>window.open(c.url,'_blank')}));
  d.pathway.forEach(p=>searchIndex.push({tag:'PATH',label:`${d.name} · ${p.title}`,action:()=>openDivision(d.id)}));
});
SPRINT.forEach(w=>w.days.forEach(d=>searchIndex.push({tag:'SPRINT',label:`Day ${d.day} — ${d.text}`,action:()=>document.getElementById('sprint').scrollIntoView()})));
CERTS.forEach(c=>searchIndex.push({tag:'CERT',label:`Cert ${c.n} — ${c.name} (${c.provider})`,action:()=>window.open(c.url,'_blank')}));
RJSC.forEach(r=>searchIndex.push({tag:'RJSC',label:`${r.title} — ${r.desc}`,action:()=>document.getElementById('rjsc').scrollIntoView()}));

const searchInput=document.getElementById('global-search');
const searchResults=document.getElementById('search-results');
searchInput.addEventListener('input',e=>{
  const q=e.target.value.trim().toLowerCase();
  if(q.length<2){searchResults.classList.remove('show');searchResults.innerHTML='';return;}
  const hits=searchIndex.filter(x=>x.label.toLowerCase().includes(q)).slice(0,20);
  if(!hits.length){searchResults.innerHTML='<div class="search-result">No matches.</div>';searchResults.classList.add('show');return;}
  searchResults.innerHTML=hits.map((h,i)=>`<div class="search-result" onclick="runSearchHit(${i})"><span class="sr-tag">${h.tag}</span>${h.label}</div>`).join('');
  searchResults._hits=hits;
  searchResults.classList.add('show');
});
function runSearchHit(i){const hit=searchResults._hits[i];if(hit){hit.action();closeModal();searchResults.classList.remove('show');}}
function clearSearch(){searchInput.value='';searchResults.classList.remove('show');searchResults.innerHTML='';}

/* ---------- BACKUP / RESTORE ---------- */
function exportProgress(){
  const blob=new Blob([JSON.stringify({sprint:sprintState,version:'4.0',exported:new Date().toISOString()},null,2)],{type:'application/json'});
  const a=document.createElement('a');a.href=URL.createObjectURL(blob);
  a.download='emon-industry-progress-'+Date.now()+'.json';a.click();
  document.getElementById('backup-status').textContent='✓ Exported';
  setTimeout(()=>document.getElementById('backup-status').textContent='',2500);
}
function importProgress(e){
  const file=e.target.files[0];if(!file)return;
  const reader=new FileReader();
  reader.onload=ev=>{
    try{
      const data=JSON.parse(ev.target.result);
      if(data.sprint){Object.assign(sprintState,data.sprint);localStorage.setItem('emon_sprint',JSON.stringify(sprintState));}
      document.getElementById('backup-status').textContent='✓ Imported — reloading…';
      setTimeout(()=>location.reload(),800);
    }catch(err){document.getElementById('backup-status').textContent='✗ Invalid file';}
  };
  reader.readAsText(file);
}

/* ---------- ANDROID BRIDGE ---------- */
if(window.EmonAndroid&&typeof window.EmonAndroid.getDeviceInfo==='function'){
  try{
    const info=JSON.parse(window.EmonAndroid.getDeviceInfo());
    const banner=document.getElementById('device-banner');
    banner.textContent=`📱 Running inside Native APK · ${info.manufacturer||''} ${info.model||''} · SDK ${info.sdk||''}`;
    banner.style.display='block';
  }catch(e){}
}

/* ---------- ARCHITECTURE SVG ---------- */
(function renderArchitecture(){
  const svg=document.getElementById('arch-svg');
  const nodes=[
    {id:'emontron',label:'Emontron',x:130,y:90,color:'#12A05A'},
    {id:'motior',label:'Motior Pharma',x:400,y:60,color:'#12A05A'},
    {id:'esecurity',label:'Esecurity',x:670,y:90,color:'#0E6B38'},
    {id:'29a',label:'29A Guardian',x:670,y:250,color:'#D61A1F'},
    {id:'eos',label:'EOS OS',x:400,y:250,color:'#0E6B38'},
    {id:'ei',label:'EMON AI',x:130,y:250,color:'#12A05A'},
    {id:'efirm',label:'Efirm',x:130,y:410,color:'#12A05A'},
    {id:'eprinter',label:'EPrinter',x:400,y:440,color:'#12A05A'},
    {id:'eapk',label:'EAPK Mobile',x:670,y:410,color:'#D61A1F'}
  ];
  const edges=[['emontron','motior'],['emontron','ei'],['esecurity','29a'],['esecurity','eos'],['29a','eos'],['ei','efirm'],['eos','efirm'],['efirm','eprinter'],['efirm','eapk'],['eos','eapk'],['motior','eprinter'],['eos','29a']];
  let g='';
  edges.forEach(([a,b])=>{
    const na=nodes.find(n=>n.id===a),nb=nodes.find(n=>n.id===b);
    g+=`<line x1="${na.x}" y1="${na.y}" x2="${nb.x}" y2="${nb.y}" stroke="#12A05A" stroke-width="1.2" stroke-dasharray="5 5" opacity="0.45"/>`;
  });
  nodes.forEach(n=>{
    g+=`<g class="arch-node">
      <circle cx="${n.x}" cy="${n.y}" r="34" fill="#14181E" stroke="${n.color}" stroke-width="2"/>
      <circle cx="${n.x}" cy="${n.y}" r="30" fill="${n.color}" opacity="0.12"/>
      <text x="${n.x}" y="${n.y+4}" text-anchor="middle" fill="#E8ECF1" font-size="11" font-weight="700" font-family="system-ui,sans-serif">${n.label.length>10?n.label.split(' ')[0]:n.label}</text>
    </g>`;
  });
  svg.innerHTML=g;
})();

/* ---------- TELEMETRY: BIO WAVEFORM ---------- */
(function bioWave(){
  const cv=document.getElementById('bio-canvas'),ctx=cv.getContext('2d');
  const W=cv.width,H=cv.height;let t=0;const pts=[];
  function draw(){
    ctx.clearRect(0,0,W,H);
    ctx.strokeStyle='#1C2128';ctx.lineWidth=1;
    for(let y=20;y<H;y+=30){ctx.beginPath();ctx.moveTo(0,y);ctx.lineTo(W,y);ctx.stroke();}
    t+=0.06;
    const bpm=72+Math.sin(t/3)*4;
    pts.length=0;
    for(let x=0;x<W;x++){
      const phase=((x/60)+(t*2))%1;let v=0;
      if(phase>0.45&&phase<0.50)v=-1;
      else if(phase>=0.50&&phase<0.55)v=1.4;
      else if(phase>=0.55&&phase<0.60)v=-0.4;
      else v=Math.sin(phase*Math.PI*2)*0.1;
      pts.push([x,H/2-v*55]);
    }
    ctx.beginPath();ctx.strokeStyle='#12A05A';ctx.lineWidth=2;
    pts.forEach((p,i)=>i?ctx.lineTo(p[0],p[1]):ctx.moveTo(p[0],p[1]));ctx.stroke();
    ctx.strokeStyle='rgba(18,160,90,.25)';ctx.lineWidth=6;ctx.stroke();
    document.getElementById('bio-readout').textContent=`BPM ${bpm.toFixed(0)} · SpO₂ ${(97+Math.sin(t)*0.6).toFixed(1)}% · Temp ${(36.6+Math.sin(t/2)*0.15).toFixed(2)}°C`;
    requestAnimationFrame(draw);
  }
  draw();
})();

/* ---------- TELEMETRY: SOC RADAR ---------- */
(function radar(){
  const cv=document.getElementById('radar-canvas'),ctx=cv.getContext('2d');
  const W=cv.width,H=cv.height,cx=W/2,cy=H/2,R=Math.min(W,H)/2-15;
  let angle=0;const blips=[];let threats=0,blocked=0;
  function spawnBlip(){
    const a=Math.random()*Math.PI*2,r=Math.random()*R*0.85;
    const color=Math.random()>0.4?'#D61A1F':'#12A05A';
    blips.push({x:cx+Math.cos(a)*r,y:cy+Math.sin(a)*r,life:1,color});
    if(color==='#D61A1F'){threats++;blocked++;}
  }
  setInterval(spawnBlip,700);
  function draw(){
    ctx.clearRect(0,0,W,H);
    [0.33,0.66,1].forEach(f=>{ctx.beginPath();ctx.arc(cx,cy,R*f,0,Math.PI*2);ctx.strokeStyle='#1C2128';ctx.lineWidth=1;ctx.stroke();});
    ctx.beginPath();ctx.moveTo(cx-R,cy);ctx.lineTo(cx+R,cy);ctx.moveTo(cx,cy-R);ctx.lineTo(cx,cy+R);ctx.strokeStyle='#1C2128';ctx.stroke();
    const g=ctx.createRadialGradient(cx,cy,0,cx,cy,R);
    g.addColorStop(0,'rgba(18,160,90,.6)');g.addColorStop(1,'rgba(18,160,90,0)');
    ctx.beginPath();ctx.moveTo(cx,cy);ctx.arc(cx,cy,R,angle,angle+0.5);ctx.closePath();ctx.fillStyle=g;ctx.fill();
    angle+=0.03;
    for(let i=blips.length-1;i>=0;i--){
      const b=blips[i];b.life-=0.008;
      if(b.life<=0){blips.splice(i,1);continue;}
      ctx.beginPath();ctx.arc(b.x,b.y,3.5,0,Math.PI*2);ctx.fillStyle=b.color;ctx.globalAlpha=b.life;ctx.fill();ctx.globalAlpha=1;
    }
    document.getElementById('radar-readout').textContent=`Threats: ${threats} · Blocked: ${blocked} · Active: ${blips.length}`;
    requestAnimationFrame(draw);
  }
  draw();
})();

/* ---------- TELEMETRY: PILLAR MATRIX ---------- */
(function pillarMatrix(){
  const cv=document.getElementById('pillar-canvas'),ctx=cv.getContext('2d');
  const W=cv.width,H=cv.height;let t=0;
  const names=['LEARN','BUILD','VALIDATE','PUBLISH','BRAND','EARN'];
  const colors=['#0E6B38','#12A05A','#D61A1F','#FF3B40','#0E6B38','#12A05A'];
  function draw(){
    ctx.clearRect(0,0,W,H);
    t+=0.02;
    const barW=(W-60)/names.length;
    names.forEach((n,i)=>{
      const h=(50+Math.sin(t+i)*25+40);
      const x=30+i*barW+10,y=H-40-h;
      ctx.fillStyle=colors[i];ctx.globalAlpha=0.85;ctx.fillRect(x,y,barW-20,h);ctx.globalAlpha=1;
      ctx.fillStyle='#E8ECF1';ctx.font='bold 10px system-ui';ctx.textAlign='center';
      ctx.fillText(n,x+(barW-20)/2,H-22);
    });
    ctx.fillStyle='#9BA5B4';ctx.font='11px system-ui';ctx.textAlign='left';
    ctx.fillText('Division execution strength across the 6 pillars',20,20);
    requestAnimationFrame(draw);
  }
  draw();
})();
</script>
</body>
</html>
EMON_HTML_EOF

echo "→ [2/5] Syncing to Android assets..."
cp docs/index.html divisions/eapk-mobile/app/src/main/assets/index.html

echo "→ [3/5] Updating MainActivity.java..."
EXISTING_JAVA=$(find divisions/eapk-mobile/app/src/main/java -name "MainActivity.java" 2>/dev/null | head -1 || true)
if [ -n "$EXISTING_JAVA" ]; then
  PKG=$(grep -oP '^package\s+\K[^;]+' "$EXISTING_JAVA" | head -1)
  JAVA_OUT="$EXISTING_JAVA"
else
  PKG="com.emonindustry.app"
  JAVA_OUT="divisions/eapk-mobile/app/src/main/java/$(echo "$PKG" | tr '.' '/')/MainActivity.java"
  mkdir -p "$(dirname "$JAVA_OUT")"
fi
echo "    package: $PKG"
echo "    target:  $JAVA_OUT"

cat > "$JAVA_OUT" << EMON_JAVA_EOF
package $PKG;

import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends Activity {
    private WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        webView = new WebView(this);
        WebSettings s = webView.getSettings();
        s.setJavaScriptEnabled(true);
        s.setDomStorageEnabled(true);
        s.setAllowFileAccess(true);
        s.setAllowContentAccess(true);
        s.setAllowFileAccessFromFileURLs(true);
        s.setAllowUniversalAccessFromFileURLs(true);
        s.setMediaPlaybackRequiresUserGesture(false);
        webView.setWebViewClient(new WebViewClient());
        webView.addJavascriptInterface(new EmonBridge(), "EmonAndroid");
        webView.loadUrl("file:///android_asset/index.html");
        setContentView(webView);
    }

    @Override
    public void onBackPressed() {
        if (webView != null && webView.canGoBack()) webView.goBack();
        else super.onBackPressed();
    }

    public class EmonBridge {
        @JavascriptInterface
        public String getDeviceInfo() {
            return "{\"platform\":\"Android\",\"model\":\"" + Build.MODEL
                 + "\",\"manufacturer\":\"" + Build.MANUFACTURER
                 + "\",\"sdk\":" + Build.VERSION.SDK_INT + "}";
        }
        @JavascriptInterface
        public String getVersion() { return "4.0"; }
    }
}
EMON_JAVA_EOF

echo "→ [4/5] Copying to SD card..."
cp docs/index.html "$SDCARD/index.html"
cp "$JAVA_OUT" "$SDCARD/MainActivity.java"
echo "    $SDCARD/index.html"
echo "    $SDCARD/MainActivity.java"

echo "→ [5/5] Git commit + push..."
git add -A
git commit -m "v4.0: visual, animated, searchable portal + telemetry + Android bridge" || echo "    (nothing new to commit)"
git push origin main || echo "    (push skipped — check credentials/network)"

echo ""
echo "══════════════════════════════════════════════════════════════"
echo " ✅ EMON INDUSTRY v4.0 DEPLOY COMPLETE"
echo "══════════════════════════════════════════════════════════════"
echo "  Web Portal  : https://mnhemon357-cyber.github.io/emon-industry/"
echo "  APK Rebuild : GitHub Actions (~80s) → releases/v1.0-latest"
echo "  Offline HTML: $HOME/emon-industry/docs/index.html"
echo "  Android Asset: divisions/eapk-mobile/app/src/main/assets/index.html"
echo "  SD Backup   : $SDCARD/"
echo "══════════════════════════════════════════════════════════════"
