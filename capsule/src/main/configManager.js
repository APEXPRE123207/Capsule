const fs = require('fs');
const path = require('path');
const { app, ipcMain } = require('electron');

class ConfigManager {
  constructor() {
    this.configPath = null;
    this.defaults = {
      alwaysOnTop: true,
      weatherCity: 'Kolkata',
      cornerRadius: 19,
      theme: 'oled-dark',
      launchOnStartup: false,
    };
    this.data = { ...this.defaults };
  }

  init() {
    try {
      this.configPath = path.join(app.getPath('userData'), 'capsule-config.json');
      if (fs.existsSync(this.configPath)) {
        const raw = fs.readFileSync(this.configPath, 'utf8');
        this.data = { ...this.defaults, ...JSON.parse(raw) };
      }
    } catch (_) {
      this.data = { ...this.defaults };
    }

    this.setupIpc();
  }

  setupIpc() {
    ipcMain.handle('get-config', () => {
      return this.getAll();
    });

    ipcMain.handle('set-config', (event, key, val) => {
      this.set(key, val);
      return true;
    });
  }

  save() {
    if (!this.configPath) return;
    try {
      fs.writeFileSync(this.configPath, JSON.stringify(this.data, null, 2), 'utf8');
    } catch (_) {}
  }

  get(key) {
    return this.data[key] ?? this.defaults[key];
  }

  set(key, value) {
    this.data[key] = value;
    this.save();
  }

  getAll() {
    return { ...this.data };
  }
}

module.exports = new ConfigManager();
