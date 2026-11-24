#!/usr/bin/env python3
"""EMON local development server; loopback-only by default."""
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from pathlib import Path
from urllib.parse import urlparse
import json, os
ROOT=Path(__file__).resolve().parents[2]/'docs'
DATA=Path(__file__).resolve().parents[2]/'data'
TASKS=DATA/'tasks.json'
class Handler(SimpleHTTPRequestHandler):
 def __init__(self,*a,**kw): super().__init__(*a,directory=str(ROOT),**kw)
 def send_json(self,status,obj):
  b=json.dumps(obj).encode(); self.send_response(status); self.send_header('Content-Type','application/json'); self.send_header('Content-Length',str(len(b))); self.send_header('Cache-Control','no-store'); self.send_header('X-Content-Type-Options','nosniff'); self.end_headers(); self.wfile.write(b)
 def do_GET(self):
  path=urlparse(self.path).path
  if path=='/api/health': return self.send_json(200,{'ok':True,'service':'EMON Local API','version':'4.2','scope':'localhost development'})
  if path=='/api/info': return self.send_json(200,{'company':'EMON INDUSTRY PVT LTD','version':'4.2','mode':'local development'})
  if path=='/api/tasks':
   try: items=json.loads(TASKS.read_text())
   except (OSError,ValueError): items=[]
   return self.send_json(200,{'items':items})
  if path=='/api/fhir/metadata': return self.send_json(200,{'resourceType':'CapabilityStatement','status':'draft','fhirVersion':'R4','kind':'instance','note':'Development scaffold only; not certified; no patient data stored.'})
  if path=='/api/fhir/Patient': return self.send_json(200,{'resourceType':'Bundle','type':'searchset','total':0,'entry':[]})
  return super().do_GET()
 def do_POST(self):
  if urlparse(self.path).path!='/api/tasks': return self.send_json(404,{'error':'Not found'})
  try:
   n=int(self.headers.get('Content-Length','0'))
   if n<0 or n>1000000: return self.send_json(413,{'error':'Payload too large'})
   obj=json.loads(self.rfile.read(n) or b'[]')
   if not isinstance(obj,list): return self.send_json(400,{'error':'Expected JSON array'})
   DATA.mkdir(exist_ok=True); TASKS.write_text(json.dumps(obj,indent=2)); return self.send_json(200,{'saved':len(obj)})
  except (ValueError,OSError): return self.send_json(400,{'error':'Invalid JSON or storage error'})
 def log_message(self,fmt,*args): print('[HTTP] '+fmt%args)
if __name__=='__main__':
 host=os.environ.get('EMON_HOST','127.0.0.1'); port=int(os.environ.get('PORT','9000'))
 print(f'EMON INDUSTRY v4.2 at http://{host}:{port} - development only')
 ThreadingHTTPServer((host,port),Handler).serve_forever()
