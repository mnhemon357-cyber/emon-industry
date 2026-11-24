# EMON INDUSTRY v4.2 - Termux Enterprise Suite

Includes responsive portal, 9 divisions, 29-day sprint, 14 learning links, browser-local progress, JSON backup/restore, report export, offline service worker, localhost Python API, FHIR-shaped development metadata, smoke tests, Android WebView assets and launch/stop helpers.

## Run in Termux
Install Python (`pkg install python`), run `termux-setup-storage`, execute this installer, then:
`cd ~/emon-industry && ./launch.sh`
Open `http://127.0.0.1:9000`. Stop with `./stop.sh`.

## Important limitations
Telemetry and SOC radar are simulated. FHIR routes are a non-certified development scaffold and store no patient data. The API binds to localhost by default. Do not expose it publicly without authentication, HTTPS, authorization, rate limiting, validation, backups and security review. This project does not claim legal registration, clinical validation or certification. APK compilation requires a complete Android Gradle project and signing configuration.

## Test
`python3 divisions/web-fullstack/test_server.py`
