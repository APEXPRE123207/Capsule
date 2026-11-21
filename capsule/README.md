# Capsule

> A modern, sleek floating Dynamic Island for Windows built with Flutter, Rust, and native Windows APIs.

---

## 🌟 Overview

**Capsule** brings fluid, organic Dynamic Island interactions to the Windows desktop. Designed with an OLED-black aesthetic, physics-inspired spring curves, and glassmorphic glow, Capsule morphs smoothly between four interaction states:

```
[ Idle Pill ] ──(Hover)──> [ Hover Peek ] ──(Click)──> [ Expanded Card ] ──(Hub Button)──> [ Max Expand Hub ]
   (210x38)                   (280x48)                     (390x180)                        (440x360)
```

---

## 📐 The Four Interaction States

| State | Size | Interaction | Features |
| :--- | :--- | :--- | :--- |
| **Idle** | `210 x 38` | Default resting state at top center | App badge, status dot, and live mini audio waveform |
| **Hover** | `280 x 48` | Mouse rests on the island | Peek track metadata (Title & Artist), live waveform, expand prompt |
| **Expanded** | `390 x 180` | Click / tap on the pill | Full media player controls (Play/Pause, Prev, Next, Shuffle), progress scrubber, and hub shortcut |
| **Max Expand** | `440 x 360` | Full modal view | Multi-tab hub with real-time **System Telemetry** (CPU/RAM/GPU), **Quick Notes**, and **System Controls** |

---

## 🏗️ Architecture & Tech Stack

```
capsule/
├── lib/
│   ├── main.dart                                    # App entrypoint & backdrop dismissal
│   ├── core/
│   │   ├── theme/capsule_theme.dart                 # Design tokens, OLED colors & spring curves
│   │   └── window/capsule_window_controller.dart    # Frameless, transparent & always-on-top windowing
│   └── features/
│       └── island/
│           ├── models/island_state.dart             # Enum & geometry definitions for the 4 states
│           └── widgets/
│               ├── capsule_island.dart              # AnimatedContainer morphing & state orchestrator
│               ├── idle_pill_view.dart              # Minimal idle view
│               ├── hover_pill_view.dart             # Interactive peek view
│               ├── expanded_card_view.dart          # Media card & scrubber
│               ├── max_expanded_view.dart           # Multi-tab widget hub
│               └── waveform_visualizer.dart         # Multi-bar animated audio equalizer
└── native/
    └── capsule_native/                              # Rust backend crate for Windows APIs & telemetry
        ├── Cargo.toml
        └── src/lib.rs
```

- **Frontend**: Flutter 3.47+ / Dart with custom spring animations and transparent windowing (`window_manager`, `screen_retriever`).
- **Backend**: Rust (`capsule_native`) with the `windows` crate for low-overhead audio transport sessions, memory/CPU metrics, and global hooks.
- **Windows APIs**: Borderless layered window, transparent composition, multi-monitor work area detection, and `WS_EX_LAYERED` / DWM integration.

---

## 🚀 Prerequisites & Setup

### 1. Visual Studio C++ Build Tools (Required by Flutter on Windows)
Flutter desktop requires the MSVC C++ toolchain to compile native runners. You can install it with `winget`:

```powershell
winget install Microsoft.VisualStudio.2022.BuildTools --override "--passive --config --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
```
*Or install [Visual Studio Community](https://visualstudio.microsoft.com/downloads/) with the "Desktop development with C++" workload.*

### 2. Rust Toolchain (For the native backend)
```powershell
winget install Rustlang.Rustup
```

### 3. Run Capsule
```powershell
cd capsule
flutter pub get
flutter run -d windows
```
