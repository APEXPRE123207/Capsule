# Capsule

A modern, sleek floating Dynamic Island for Windows built with Flutter, Rust, and native Windows APIs.

---

## 🌟 Overview

**Capsule** brings fluid, organic Dynamic Island interactions to the Windows desktop. Designed with an OLED-black aesthetic, physics-inspired spring curves, and glassmorphic glow, Capsule morphs smoothly between four interaction states:

```
[ Idle Pill ] ──(Hover)──> [ Hover Peek ] ──(Click)──> [ Expanded Card ] ──(Hub Button)──> [ Max Expand Hub ]
   (210x38)                   (280x48)                     (390x180)                        (440x360)
```

---

## 🏗️ Repository Layout

- **[capsule/](capsule/)**: Main Flutter application (Dynamic Island widgets, animations, windowing).
- **[capsule/native/](capsule/native/)**: Rust backend crate (`capsule_native`) for low-overhead Windows system telemetry & audio transport sessions.
- **[.github/workflows/build-windows.yml](.github/workflows/build-windows.yml)**: GitHub Actions workflow that compiles and packages the Windows `.exe` and `.zip` automatically.

---

## 🚀 Getting Started

### Local UI Preview (Web / Chrome)
Preview and test animations with instant hot reload without needing Visual Studio:
```powershell
cd capsule
flutter pub get
flutter run -d chrome
```

### Windows Desktop Build (GitHub Actions)
Push changes to `main` or trigger the workflow manually in the Actions tab. GitHub Actions compiles the Windows x64 release and attaches `capsule-windows-x64.zip` to the build artifacts.
