# Capsule

A sleek, lightweight Apple Dynamic Island inspired floating widget for Windows, built with native Acrylic/Mica transparency, Web technologies (React, TypeScript, CSS), and Tauri desktop runtime.

---

## 🌟 Overview

**Capsule** brings fluid, organic Dynamic Island interactions to the Windows desktop. Featuring native hardware DWM composition, smooth spring animations, and crystal-clear translucent rounded surfaces without any black box artifacting, Capsule morphs dynamically between four primary states:

```
[ Idle Pill ] ──(Hover)──> [ Hover Peek ] ──(Click)──> [ Expanded Card ] ──(Expand)──> [ Max Expand Hub ]
```

1. **Idle State**: Minimal floating pill showing live animated status, clock, and media indicators. Passes mouse clicks through to underlying desktop applications when inactive.
2. **Hover State**: Subtle peek view showing album art, scrolling track info, quick playback controls, and quick action buttons (hide, quit).
3. **Expanded State**: Dashboard card with Overview widgets (weather, clock, system status), Music & Lyrics with synchronized scroll, System Performance monitors (CPU, RAM, disk), and Toolbox utilities.
4. **Max Expand Hub**: Full application dashboard:
   - 🎵 **Music & Lyrics**: Full lyrics display with synchronized auto-scrolling and playback controls.
   - 🖼 **Album**: Media artwork viewer and playlist/track info.
   - 📋 **Clipboard Manager**: Clipboard history manager with instant copy-back.
   - 🔍 **File Search**: Quick local file and application search.
   - 🔖 **URL Favorites**: Quick link bookmarks and shortcuts.
   - 🧮 **Scientific Calculator**: Full scientific arithmetic and functions.
   - 🛠 **Toolbox**: Unit converter, color picker, and utilities.
   - ⚙️ **Settings**: Customizable corner radius, startup behavior, position, and styling.

---

## 🛑 Guaranteed Normal Closing & User Control

Capsule is built to always remain under the user's complete control:
- **Visible Exit Controls**: Power-off / Quit buttons are accessible in the hover bar, the MaxExpand controls, and the tray menu.
- **System Tray Menu**: Right-click the Capsule tray icon and select **Quit** to immediately exit and terminate all background workers.
- **Keyboard Shortcut**: Press `Alt+F4` or close the main window to cleanly exit.
- **Clean Teardown**: Zero watchdog processes, no auto-restarting loops, no background zombies, and no shutdown blockers.

---

## 🔨 Cloud Build via GitHub Actions

Capsule is continuously compiled and packaged using GitHub Actions:
- **Workflow**: `.github/workflows/build.yml`
- **Runner**: `windows-latest`
- **Output Artifact**: `capsule-windows-x64.zip` containing both:
  - `capsule.exe` (Standalone Windows executable)
  - `Capsule_1.0.0_x64-setup.exe` (NSIS Installer)

---

## 📜 License

GPL-3.0 License.
