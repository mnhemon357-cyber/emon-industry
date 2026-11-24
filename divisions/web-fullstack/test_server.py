import json,os,subprocess,sys,time,urllib.request
from pathlib import Path
root=Path(__file__).resolve().parents[2]; port=19091; env=os.environ.copy(); env['PORT']=str(port)
p=subprocess.Popen([sys.executable,str(root/'divisions/web-fullstack/server.py')],cwd=root,env=env,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
try:
 for _ in range(30):
  try:
   with urllib.request.urlopen(f'http://127.0.0.1:{port}/api/health',timeout=1) as r: assert json.load(r)['ok']; break
  except Exception: time.sleep(.2)
 else: raise RuntimeError('health endpoint unavailable')
 with urllib.request.urlopen(f'http://127.0.0.1:{port}/api/fhir/metadata') as r: assert json.load(r)['resourceType']=='CapabilityStatement'
 with urllib.request.urlopen(f'http://127.0.0.1:{port}/index.html') as r: assert r.status==200
 print('PASS: health, FHIR metadata and portal smoke tests')
finally: p.terminate(); p.wait(timeout=5)
