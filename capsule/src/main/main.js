const { app, BrowserWindow, globalShortcut } = require('electron');
const configManager = require('./configManager');
const windowManager = require('./windowManager');
const trayManager = require('./trayManager');
require('./mediaManager');
require('./systemIntegration');

// Single instance enforcement
const gotTheLock = app.requestSingleInstanceLock();
if (!gotTheLock) {
  app.quit();
} else {
  app.on('second-instance', () => {
    windowManager.show();
  });
}

app.whenReady().then(() => {
  // Initialize configuration
  configManager.init();

  // Create main floating island window
  windowManager.createWindow();

  // Create system tray icon with context menu
  trayManager.createTray();

  // Register Alt+F4 to quit cleanly
  globalShortcut.register('Alt+F4', () => {
    app.isQuitting = true;
    app.quit();
  });

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      windowManager.createWindow();
    } else {
      windowManager.show();
    }
  });
});

app.on('will-quit', () => {
  globalShortcut.unregisterAll();
});

app.on('window-all-closed', () => {
  app.isQuitting = true;
  app.quit();
});
