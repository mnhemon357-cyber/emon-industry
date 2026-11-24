# EMON Academy v5.0 — Termux all-in-one
- Original responsive cybersecurity learning website in `docs/`.
- Offline service worker and browser-local progress tracker.
- Android WebView project in `divisions/eapk-mobile/`.
- GitHub Actions workflow builds a debug APK and uploads it as an artifact.
- Local preview server binds to 127.0.0.1 only.
- Installer backs up pre-existing generated website/app files.
- No root access or third-party API token required.

## Local preview
`./launch.sh` then open `http://127.0.0.1:9000`
Stop with `./stop.sh`.

## APK
Push the repository to GitHub, then open Actions → Build EMON Academy APK.
The generated artifact is a debug APK. A production release requires secure
release signing and review.

## Safety
Training checklists are educational only. Only assess systems you own or have
explicit written permission to test. No live SOC telemetry, real device sensor
feed, medical service, or external target scanning is implemented.
