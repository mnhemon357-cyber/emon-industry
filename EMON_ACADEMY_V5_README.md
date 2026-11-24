# EMON Academy v5.0

Original EMON INDUSTRY cybersecurity learning portal and Android WebView app.
The design is independently authored; it does not use OffSec branding, artwork,
source code, credentials, API tokens or private assets.

## Website
Open `docs/index.html` locally, or publish the `docs/` folder with GitHub Pages.
The site includes pathways, authorized practice labs, a 12-step progress tracker,
search, resource links, JSON progress export and an offline service worker.

## Android APK
The Android project is in `divisions/eapk-mobile/`. Push to GitHub and run the
"Build EMON Academy APK" workflow, or build locally with JDK 17, Android SDK 35
and Gradle 8.9+:
`cd divisions/eapk-mobile && gradle assembleDebug`
APK output:
`app/build/outputs/apk/debug/app-debug.apk`

The debug APK is for testing. A production release requires a protected signing
key and a separate release build/signing workflow.

## Safety
The included labs are learning checklists only; they do not attack or scan targets.
Only test systems you own or have explicit written permission to assess.
