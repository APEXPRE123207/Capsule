# Capsule

A sleek, lightweight Windows Dynamic Island desktop application built with **Electron, JavaScript, HTML, and CSS**.

---

## 🌟 Overview

**Capsule** brings fluid, organic Dynamic Island interactions to the Windows desktop. Designed with an OLED-black aesthetic, smooth CSS spring transitions, and transparent click-through windowing, Capsule morphs between four interaction states:

```
[ Idle Pill ] ──(Hover)──> [ Hover Peek ] ──(Click)──> [ Expanded Card ] ──(Hub Button)──> [ Max Expand Hub ]
   (210x38)                   (290x48)                     (390x185)                        (460x400)
```

1. **Idle State (`210x38`)**: Minimal floating pill showing live animated waveform, current track / status, system clock, and weather icon. Transparent click-through allows clicks to pass to underlying desktop apps.
2. **Hover State (`290x48`)**: Subtle peek view showing album art, scrolling track marquee, quick play/pause, and ambient weather temperature badge.
3. **Expanded State (`390x185`)**: Media card with album artwork, title, artist, seek/progress bar, media controls (⏮, ⏯, ⏭), master volume slider, minimize (`_`), and a prominent close button (`✕`).
4. **Max Expand State (`460x400`)**: Full multi-tab dashboard hub:
   - 🎵 **Music & Lyrics**: Synchronized scrolling lyrics powered by LRCLIB with active line highlighting and playback controls.
   - 🌤 **Weather**: Open-Meteo real-time weather conditions, humidity, wind speed, UV index, and 3-day forecast.
   - ⚡ **System Telemetry**: Real-time CPU & RAM usage meters, system uptime, and master volume control.
   - 🧮 **Toolbox**: Scientific Calculator with arithmetic, trigonometric functions (`sin`, `cos`, `tan`), roots, and powers.
   - 📋 **Clipboard Manager**: Clipboard history list with 1-click copy-back to clipboard.
   - 🚀 **App Launcher & File Search**: Quick app launcher grid (Explorer, CMD, Settings, Spotify, etc.) + instant local desktop/documents file search.
   - ⚙️ **Settings**: Always-on-top toggle, weather city customization, island corner radius slider, and explicit application exit.

---

## 🛑 Guaranteed Normal Closing & Control

Capsule is designed to be completely user-controlled with predictable desktop behavior:
- **Visible Close Buttons**: Prominent `✕` close buttons are present in both Expanded and Max Expand views.
- **System Tray Menu**: Right-click the Capsule tray icon and select **Exit Capsule** to immediately terminate the process.
- **Global Shortcut**: Press `Alt+F4` at any time to close and quit the application cleanly.
- **Zero Resistance**: No watchdog processes, no shutdown blockers, no zombie services.

---

## 🚀 Development & Usage

### Prerequisites
- Node.js (v20+ recommended)
- npm

### Running Locally
```powershell
cd capsule
npm install
npm start
```

### Static Checks
```powershell
npm test
```

### Building Standalone Executable
```powershell
npm run package
```
This produces a portable Windows executable in `capsule/dist/capsule-win32-x64/`.

---

## 🏗️ Automated GitHub Actions CI/CD

Every push to `main` triggers [.github/workflows/build-windows.yml](.github/workflows/build-windows.yml), which:
1. Installs Node.js dependencies
2. Runs static syntax tests
3. Packages the standalone Windows x64 executable
4. Generates and uploads `capsule-windows-x64.zip` as a downloadable artifact.
