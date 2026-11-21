const { BrowserWindow, screen, ipcMain, app } = require('electron');
const path = require('path');
const configManager = require('./configManager');

class WindowManager {
  constructor() {
    this.mainWindow = null;
    this.states = {
      'idle': { width: 210, height: 44 },
      'hover': { width: 290, height: 54 },
      'expanded': { width: 390, height: 195 },
      'max-expand': { width: 460, height: 410 },
    };
    this.currentState = 'idle';
  }

  createWindow() {
    const primaryDisplay = screen.getPrimaryDisplay();
    const { workArea } = primaryDisplay;
    const initialSize = this.states['idle'];

    const x = Math.round(workArea.x + (workArea.width - initialSize.width) / 2);
    const y = workArea.y + 6;

    this.mainWindow = new BrowserWindow({
      x,
      y,
      width: initialSize.width,
      height: initialSize.height,
      transparent: true,
      frame: false,
      resizable: false,
      alwaysOnTop: true,
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

    this.mainWindow.setAlwaysOnTop(true, 'screen-saver');
    this.mainWindow.loadFile(path.join(__dirname, '../renderer/index.html'));

    this.mainWindow.once('ready-to-show', () => {
      this.mainWindow.show();
      this.mainWindow.focus();
    });

    // Fallback ensure show
    setTimeout(() => {
      if (this.mainWindow && !this.mainWindow.isDestroyed() && !this.mainWindow.isVisible()) {
        this.mainWindow.show();
      }
    }, 500);

    // Handle normal closing cleanly
    this.mainWindow.on('closed', () => {
      this.mainWindow = null;
    });

    this.setupIpc();
  }

  setIslandState(state) {
    if (!this.mainWindow || this.mainWindow.isDestroyed()) return;
    const target = this.states[state] || this.states['idle'];
    this.currentState = state;

    const primaryDisplay = screen.getPrimaryDisplay();
    const { workArea } = primaryDisplay;
    const x = Math.round(workArea.x + (workArea.width - target.width) / 2);
    const y = workArea.y + 6;

    this.mainWindow.setBounds({
      x,
      y,
      width: target.width,
      height: target.height,
    }, true);
  }

  setupIpc() {
    // Dynamic island state resize & reposition
    ipcMain.on('set-island-state', (event, state) => {
      this.setIslandState(state);
    });

    // Close application cleanly on request
    ipcMain.on('app-exit', () => {
      app.isQuitting = true;
      app.quit();
    });

    // Minimize window
    ipcMain.on('app-minimize', () => {
      this.setIslandState('idle');
      if (this.mainWindow && !this.mainWindow.isDestroyed()) {
        this.mainWindow.webContents.send('force-idle-state');
      }
    });

    // Always on top toggle
    ipcMain.handle('set-always-on-top', (event, flag) => {
      if (this.mainWindow && !this.mainWindow.isDestroyed()) {
        this.mainWindow.setAlwaysOnTop(flag, flag ? 'screen-saver' : 'normal');
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
      this.mainWindow.setAlwaysOnTop(true, 'screen-saver');
    }
  }

  hide() {
    if (this.mainWindow && !this.mainWindow.isDestroyed()) {
      this.mainWindow.hide();
    }
  }
}

module.exports = new WindowManager();
