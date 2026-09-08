# WareWatch — Mobile App

Cross-platform field intelligence assistant for warehouse supervisors. Provides live camera monitoring with real-time detection overlays, safety violation alerts, an AI operations assistant, and incident video clip playback.

**Stack**: Flutter 3 · Dart · BLoC · GoRouter · Firebase Auth · Google Sign-In

---

## Setup

```bash
cp .env.example .env    # set BACKEND_URL
flutter pub get
flutter run
```

### Configuring the Backend URL

Edit `.env` and set `BACKEND_URL` to wherever the backend is running:

```
BACKEND_URL=http://<your-machine-ip>:8080
```

Use `localhost` for desktop, `10.0.2.2` for Android emulator, or your LAN IP for a physical device.

---

## App Structure

```
lib/
├── core/           Theme, services, Firebase init
├── common/         Shared widgets, network client, models
├── routes/         GoRouter config with auth guards
└── features/
    ├── auth/       Sign in, sign up, password reset
    ├── home/       Shell screen with bottom navigation
    ├── monitoring/ Live camera grid + MJPEG video viewer
    ├── alerts/     Incident list, severity filters, acknowledgment
    ├── wwai/       AI supervisor chat with streamed responses
    ├── archive/    Incident clip video player
    └── settings/   Profile and server configuration
```

---

## Features

**Monitoring** — Live multi-camera grid streaming annotated CCTV feeds with bounding boxes highlighting detected hazards.

**Alerts** — Real-time incident feed color-coded by severity (CRITICAL / HIGH / MEDIUM / LOW). Tap to view the detection snapshot and acknowledge.

**WareWatch AI** — Conversational assistant backed by an on-premise LLM. Ask questions like "show me unacknowledged alerts" or "which dock had the most incidents today" and get structured answers derived from live warehouse data.

**Archive** — Browse and play back 3-second incident video clips automatically captured at the moment of each detected violation.
