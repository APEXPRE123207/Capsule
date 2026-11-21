const { ipcMain, clipboard } = require('electron');
const os = require('os');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

class SystemIntegration {
  constructor() {
    this.lastCpus = os.cpus();
    this.setupIpc();
  }

  setupIpc() {
    // 1. System Telemetry (CPU & RAM)
    ipcMain.handle('get-system-metrics', () => {
      const cpus = os.cpus();
      let idle = 0;
      let total = 0;

      for (let i = 0; i < cpus.length; i++) {
        const cpu = cpus[i];
        const last = this.lastCpus[i] || cpu;

        for (const type in cpu.times) {
          total += cpu.times[type] - last.times[type];
        }
        idle += cpu.times.idle - last.times.idle;
      }

      this.lastCpus = cpus;
      const cpuUsage = total > 0 ? Math.round(((total - idle) / total) * 100) : 15;

      const totalMem = os.totalmem();
      const freeMem = os.freemem();
      const usedMem = totalMem - freeMem;

      return {
        cpuUsage: Math.min(100, Math.max(0, cpuUsage)),
        ramPercent: Math.round((usedMem / totalMem) * 100),
        ramUsedGb: (usedMem / (1024 ** 3)).toFixed(1),
        ramTotalGb: (totalMem / (1024 ** 3)).toFixed(0),
        uptimeHours: (os.uptime() / 3600).toFixed(1),
      };
    });

    // 2. Audio Volume Controls
    ipcMain.handle('set-volume', (event, level) => {
      // level between 0 and 100
      const script = `$wsh = New-Object -ComObject WScript.Shell; 1..50 | % { $wsh.SendKeys([char]174) }; 1..${Math.round(level / 2)} | % { $wsh.SendKeys([char]175) }`;
      exec(`powershell -NoProfile -Command "${script}"`, () => {});
      return true;
    });

    ipcMain.handle('toggle-mute', () => {
      const script = `$wsh = New-Object -ComObject WScript.Shell; $wsh.SendKeys([char]173)`;
      exec(`powershell -NoProfile -Command "${script}"`, () => {});
      return true;
    });

    // 3. Application Launcher Discovery
    ipcMain.handle('get-installed-apps', async () => {
      return this.discoverApps();
    });

    ipcMain.handle('launch-app', (event, appPath) => {
      if (appPath.startsWith('ms-settings:')) {
        exec(`start ${appPath}`);
        return true;
      }
      exec(`start "" "${appPath}"`);
      return true;
    });

    // 4. Local File Search
    ipcMain.handle('search-files', async (event, query) => {
      return this.searchLocalFiles(query);
    });

    ipcMain.handle('open-file', (event, filePath) => {
      exec(`explorer.exe /select,"${filePath}"`);
      return true;
    });

    // 5. Desktop Wallpaper
    ipcMain.handle('set-wallpaper', (event, filePath) => {
      const script = `Add-Type -TypeDefinition '[DllImport("user32.dll", SetLastError = true)] public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);' -Name Win32 -Namespace Wallpaper; [Wallpaper.Win32]::SystemParametersInfo(20, 0, "${filePath.replace(/\\/g, '\\\\')}", 3)`;
      exec(`powershell -NoProfile -Command "${script}"`, () => {});
      return true;
    });

    // 6. Clipboard Access
    ipcMain.handle('read-clipboard', () => {
      return clipboard.readText();
    });

    ipcMain.handle('write-clipboard', (event, text) => {
      clipboard.writeText(text);
      return true;
    });
  }

  discoverApps() {
    const defaultApps = [
      { name: 'File Explorer', path: 'explorer.exe', icon: '📁' },
      { name: 'Command Prompt', path: 'cmd.exe', icon: '💻' },
      { name: 'PowerShell', path: 'powershell.exe', icon: '⚡' },
      { name: 'Task Manager', path: 'taskmgr.exe', icon: '📊' },
      { name: 'Notepad', path: 'notepad.exe', icon: '📝' },
      { name: 'Calculator', path: 'calc.exe', icon: '🧮' },
      { name: 'Settings', path: 'ms-settings:', icon: '⚙️' },
      { name: 'Google Chrome', path: 'chrome.exe', icon: '🌐' },
      { name: 'Microsoft Edge', path: 'msedge.exe', icon: '🌍' },
      { name: 'Spotify', path: 'spotify.exe', icon: '🎵' },
    ];

    try {
      const userProfile = process.env.USERPROFILE;
      const startMenu = path.join(userProfile, 'AppData/Roaming/Microsoft/Windows/Start Menu/Programs');
      if (fs.existsSync(startMenu)) {
        const files = fs.readdirSync(startMenu);
        for (const file of files) {
          if (file.endsWith('.lnk')) {
            const name = file.replace('.lnk', '');
            if (!defaultApps.some((a) => a.name === name)) {
              defaultApps.push({ name, path: path.join(startMenu, file), icon: '🚀' });
            }
          }
        }
      }
    } catch (_) {}

    return defaultApps;
  }

  searchLocalFiles(query) {
    if (!query || query.trim().length === 0) return [];
    const q = query.toLowerCase().trim();
    const results = [];
    const userProfile = process.env.USERPROFILE;
    if (!userProfile) return [];

    const dirs = [
      path.join(userProfile, 'Desktop'),
      path.join(userProfile, 'Documents'),
      path.join(userProfile, 'Downloads'),
    ];

    for (const dir of dirs) {
      try {
        if (!fs.existsSync(dir)) continue;
        const entries = fs.readdirSync(dir, { withFileTypes: true });
        for (const entry of entries) {
          if (entry.name.toLowerCase().includes(q)) {
            const fullPath = path.join(dir, entry.name);
            results.push({
              name: entry.name,
              path: fullPath,
              isDirectory: entry.isDirectory(),
            });
            if (results.length >= 25) break;
          }
        }
      } catch (_) {}
      if (results.length >= 25) break;
    }

    return results;
  }
}

module.exports = new SystemIntegration();
