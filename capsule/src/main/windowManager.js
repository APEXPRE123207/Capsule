const { BrowserWindow, screen, ipcMain, app } = require('electron');
const path = require('path');
const configManager = require('./configManager');

class WindowManager {
  constructor() {
    this.mainWindow = null;
    this.windowWidth = 520;
    this.windowHeight = 480;
  }

  createWindow() {
    const primaryDisplay = screen.getPrimaryDisplay();
    const { workArea } = primaryDisplay;

    const x = Math.round(workArea.x + (workArea.width - this.windowWidth) / 2);
    const y = workArea.y;

    this.mainWindow = new BrowserWindow({
      x,
      y,
      width: this.windowWidth,
      height: this.windowHeight,
      transparent: true,
      frame: false,
      resizable: false,
      alwaysOnTop: configManager.get('alwaysOnTop'),
      skipTaskbar: false,
      hasShadow: false,
      show: false,
      webPreferences: {
        preload: path.join(__dirname, '../preload/preload.js'),
        contextIsolation: true,
        nodeIntegration: false,
        sandbox: false,
      },
    });

    this.mainWindow.loadFile(path.join(__dirname, '../renderer/index.html'));

    this.mainWindow.once('ready-to-show', () => {
      this.mainWindow.show();
    });

    // Handle normal closing cleanly
    this.mainWindow.on('closed', () => {
      this.mainWindow = null;
    });

    this.setupIpc();
  }

  setupIpc() {
    // Mouse transparency / pass-through control
    ipcMain.on('set-ignore-mouse-events', (event, ignore, options) => {
      const win = BrowserWindow.fromWebContents(event.sender);
      if (win && !win.isDestroyed()) {
        win.setIgnoreMouseEvents(ignore, options || { forward: true });
      }
    });

    // Close application cleanly on request
    ipcMain.on('app-exit', () => {
      app.isQuitting = true;
      app.quit();
    });

    // Minimize window
    ipcMain.on('app-minimize', () => {
      if (this.mainWindow && !this.mainWindow.isDestroyed()) {
        this.mainWindow.minimize();
      }
    });

    // Always on top toggle
    ipcMain.handle('set-always-on-top', (event, flag) => {
      if (this.mainWindow && !this.mainWindow.isDestroyed()) {
        this.mainWindow.setAlwaysOnTop(flag);
        configManager.set('alwaysOnTop', flag);
        return true;
      }
      return false;
    });
  }

  show() {
    if (this.mainWindow && !this.mainWindow.isDestroyed()) {
      if (this.mainWindow.isMinimized()) this.mainWindow.restore();
      this.mainWindow.show();
      this.mainWindow.focus();
    }
  }

  hide() {
    if (this.mainWindow && !this.mainWindow.isDestroyed()) {
      this.mainWindow.hide();
    }
  }
}

module.exports = new WindowManager();
