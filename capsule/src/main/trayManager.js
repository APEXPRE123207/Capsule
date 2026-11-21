const { Tray, Menu, app, nativeImage } = require('electron');
const path = require('path');
const windowManager = require('./windowManager');

class TrayManager {
  constructor() {
    this.tray = null;
  }

  createTray() {
    // Generate a clean 16x16 tray icon programmatically or from asset
    const icon = this.createDefaultIcon();
    this.tray = new Tray(icon);
    this.tray.setToolTip('Capsule — Windows Dynamic Island');

    const contextMenu = Menu.buildFromTemplate([
      {
        label: 'Show Capsule',
        click: () => {
          windowManager.show();
        },
      },
      {
        label: 'Toggle Island State',
        click: () => {
          if (windowManager.mainWindow) {
            windowManager.mainWindow.webContents.send('toggle-island-state');
          }
        },
      },
      { type: 'separator' },
      {
        label: 'Exit Capsule',
        click: () => {
          app.isQuitting = true;
          app.quit();
        },
      },
    ]);

    this.tray.setContextMenu(contextMenu);

    this.tray.on('click', () => {
      windowManager.show();
    });
  }

  createDefaultIcon() {
    // 16x16 PNG Buffer with cyan circle representing Capsule
    const base64Icon = 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAZElEQVQ4T2NkoBAwUqifYdQAI6iH0YmPj+9/UJD/f1yGIbEBhgaGBgb8BBlw8ODBn1AMYyMDA0MDVsU4FWEzA6cBGIbA+FAbwG2AhobGn7AMQ3EDTBgYGBhgGBvGBtGkG7UBAKk/GBn8m4jRAAAAAElFTkSuQmCC';
    return nativeImage.createFromBuffer(Buffer.from(base64Icon, 'base64'));
  }
}

module.exports = new TrayManager();
