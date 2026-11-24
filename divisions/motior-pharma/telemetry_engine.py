#!/usr/bin/env python3
import json, os, subprocess, datetime

def read_sensor():
    bin_path = os.path.join(os.path.dirname(__file__), "..", "emontron", "sensor_node")
    if os.path.isfile(bin_path) and os.access(bin_path, os.X_OK):
        raw = subprocess.check_output([bin_path], timeout=3).decode().strip()
        return json.loads(raw)
    return {"division": "DIV-01 Emontron (Sim)", "node": "SIM-01", "temp_c": 36.8, "spo2": 98, "bpm": 74, "bus_voltage": 12.1}

def evaluate_clinical(data):
    alerts = []
    if data["temp_c"] >= 38.0:
        alerts.append(f"FEVER_ALERT ({data['temp_c']} C)")
    if data["spo2"] < 94:
        alerts.append(f"HYPOXIA_ALERT (SpO2 {data['spo2']}%)")
    if data["bpm"] > 100 or data["bpm"] < 55:
        alerts.append(f"CARDIAC_RATE_ALERT ({data['bpm']} BPM)")

    status = "CRITICAL" if alerts else "OPTIMAL"
    now = datetime.datetime.now(datetime.timezone.utc).isoformat()
    return {
        "resourceType": "Observation",
        "division": "DIV-09 Motior Pharma",
        "status": "final",
        "clinicalStatus": status,
        "alerts": alerts,
        "effectiveDateTime": now,
        "sensorSource": data,
        "component": [
            {"code": {"text": "Body Temperature"}, "valueQuantity": {"value": data["temp_c"], "unit": "Cel"}},
            {"code": {"text": "SpO2"}, "valueQuantity": {"value": data["spo2"], "unit": "%"}},
            {"code": {"text": "Heart Rate"}, "valueQuantity": {"value": data["bpm"], "unit": "beats/min"}}
        ]
    }

if __name__ == "__main__":
    print(json.dumps(evaluate_clinical(read_sensor()), indent=2))
