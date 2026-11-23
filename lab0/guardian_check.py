import hashlib, socket

sig = hashlib.sha256(b"EMON_INDUSTRY_29A").hexdigest()
print("[29A PYTHON] SHA-256 Signature:", sig)

with socket.socket() as s:
    s.settimeout(0.5)
    print("[29A PYTHON] Local Port 80 Open?:", s.connect_ex(("127.0.0.1", 80)) == 0)
