/* ===== v4.1 add-ons ===== */
document.querySelectorAll("main h2").forEach((h,i)=>{h.id="s"+i});
(function(){const n=document.createElement("nav");n.className="chips";
n.innerHTML=[...document.querySelectorAll("main h2")].map(h=>`<a href="#${h.id}">${h.textContent.replace(/&.*$/,"").slice(0,20)}</a>`).join("");
document.querySelector("header").after(n)})();
document.querySelector("header").insertAdjacentHTML("afterbegin",'<svg viewBox="0 0 96 64" style="width:84px;height:56px;display:block;margin:0 auto 6px;border:2px solid #3a444e;border-radius:3px;background:none"><rect width="96" height="21" fill="#0B0E11"/><rect y="21" width="96" height="22" fill="#fff"/><rect y="43" width="96" height="21" fill="#0E6B38"/><polygon points="0,0 28,32 0,64" fill="#D61A1F"/><polygon points="62,10 80,32 62,54 44,32" fill="#fff" stroke="#0B0E11" stroke-width="2"/><line x1="62" y1="16" x2="62" y2="48" stroke="#0B0E11" stroke-width="2"/><path d="M55,22Q62,28 55,33Q62,38 55,43M69,22Q62,28 69,33Q62,38 69,43" fill="none" stroke="#0E6B38" stroke-width="1.6"/></svg>');
document.querySelector("header").insertAdjacentHTML("beforeend",'<div class="m" style="margin-top:6px">9 Divisions &middot; 6 Pillars &middot; 29-Day Sprint &middot; 14 Certifications</div>');
addEventListener("keydown",e=>{const t=document.activeElement.tagName;if(e.key=="/"&&t!="INPUT"&&t!="TEXTAREA"){e.preventDefault();$("#q").focus()}});

function trk(){const s=S.start;let h=`<b>Sprint Tracker</b><br><input type="date" id="sd" value="${s||""}" onchange="S.start=this.value;save();trk()">`;
 if(s){const n=Math.floor((Date.now()-new Date(s))/864e5)+1,c=Math.min(Math.max(n,1),29),dn=Object.values(S.d).filter(Boolean).length;
 h+=`<p>${n<1?"Starts in "+(1-n)+" day(s)":n>29?"Sprint window ended (day "+n+")":"Today: Day "+n+" of 29"}<br>Task: ${DAYS[c-1]}<br>Done ${dn}/29 &mdash; ${dn<Math.min(Math.max(n,0),29)?"behind by "+(Math.min(n,29)-dn):"on track"}</p>`}
 $("#t0").innerHTML=h}
function v_pr(){const p=+$("#pg").value||0,c=Math.min(+$("#cl").value||0,p),k=+$("#cp").value||1,b=p-c;$("#pro").textContent=`B&W ${b} x 2 + Color ${c} x 5 = ${(b*2+c*5)*k} BDT for ${k} copies`}
function v_vat(){const a=+$("#va").value||0,r=+$("#vr").value||0,x=+$("#vx").value||1,v=a*r/100;$("#vo").textContent=`VAT ${v.toFixed(2)} | Total ${(a+v).toFixed(2)} BDT | about ${((a+v)/x).toFixed(2)} USD`}
async function v_h(){try{const b=await crypto.subtle.digest("SHA-256",new TextEncoder().encode($("#hi").value));$("#ho").textContent=[...new Uint8Array(b)].map(x=>x.toString(16).padStart(2,"0")).join("")}catch(e){$("#ho").textContent="SHA-256 needs a secure context (https or the app)"}}
function v_ls(){$("#li").value="Nov 24 sshd: Failed password for root from 203.0.113.9\nNov 24 sshd: Failed password for admin from 203.0.113.9\nNov 24 sshd: Invalid user test from 203.0.113.9\nNov 24 sshd: Accepted password for emon from 192.168.0.5\nNov 24 ufw: DENIED 198.51.100.7";v_lg()}
function v_lg(){const m={};$("#li").value.split("\n").forEach(l=>{if(/fail|denied|invalid|refused/i.test(l)){const ip=(l.match(/\b\d{1,3}(\.\d{1,3}){3}\b/)||["unknown"])[0];m[ip]=(m[ip]||0)+1}});
 const r=Object.entries(m).sort((a,b)=>b[1]-a[1]);$("#lo").innerHTML=r.length?r.map(([ip,n])=>`<label>${ip}: ${n} hit(s) ${n>=3?"<b style='color:#D61A1F'>BLOCK</b>":"watch"}</label>`).join(""):"<p class=m>No suspicious lines</p>"}
function v_tr(){const b=+$("#tb").value,s=+$("#ts").value,t=+$("#tt").value,r=[];if(s&&s<92)r.push("CRITICAL: low SpO2");if(b>120||(b&&b<50))r.push("WARN: abnormal BPM");if(t>=38)r.push("WARN: fever");if(t&&t<35)r.push("CRITICAL: hypothermia");$("#to").textContent=r.length?r.join(" | "):"Within normal demo range"}
const v_pz=[15000,25000,40000,8000,20000,12000,30000,2000,18000];
$("#rv").innerHTML=D.map((x,i)=>`<div class="m">${x[1]}<br><input id="rc${x[0]}" type="number" value="1" oninput="v_rv()"><input id="rp${x[0]}" type="number" value="${v_pz[i]}" oninput="v_rv()"></div>`).join("");
function v_rv(){let t=0;D.forEach(x=>{t+=(+$("#rc"+x[0]).value||0)*(+$("#rp"+x[0]).value||0)});$("#ro").textContent=`Monthly ${t.toLocaleString()} BDT | Annual ${(t*12).toLocaleString()} BDT | about ${Math.round(t*12/120).toLocaleString()} USD/yr`}
function v_mx(){$("#mx").innerHTML=D.map(x=>{let n=0;for(let i=0;i<6;i++)if(S.p&&S.p[x[0]+"_"+i])n++;return `<label>${x[1]} <small>${n}/6 pillars</small><div class="bar" style="margin-top:4px"><i style="width:${n/6*100}%"></i></div></label>`}).join("")}
function v_pp(k,v){S.p=S.p||{};S.p[k]=v;save();v_mx()}
const v_o=openD;
openD=function(n){v_o(n);$("#md").insertAdjacentHTML("beforeend","<h2>F. Pillar Progress</h2>"+PL.map((p,i)=>`<label><input type="checkbox" ${S.p&&S.p[n+"_"+i]?"checked":""} onchange="v_pp('${n}_${i}',this.checked)">${i+1}. ${p}</label>`).join(""))};
function v_dl(){try{const a=document.createElement("a");a.href=URL.createObjectURL(new Blob([JSON.stringify(S)],{type:"application/json"}));a.download="emon-progress.json";a.click()}catch(e){ex();alert("Copied to the backup box instead")}}
function v_sh(){ex();try{navigator.share&&navigator.share({title:"EMON progress",text:JSON.stringify(S)})}catch(e){}}
function v_rs(){if(confirm("Erase all progress?")){S={d:{},c:{}};save();render();v_all()}}
im=function(){try{const o=JSON.parse($("#bk").value);if(typeof o!="object"||!o)throw 0;Object.assign(S,o);S.d=S.d||{};S.c=S.c||{};save();render();v_all();alert("Restored")}catch(e){alert("Invalid backup")}};
function v_all(){trk();v_pr();v_vat();v_tr();v_rv();v_mx()}
v_all();
