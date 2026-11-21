const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('capsuleAPI', {
  // Window controls
  exitApp: () => ipcRenderer.send('app-exit'),
  minimizeApp: () => ipcRenderer.send('app-minimize'),
  setIgnoreMouseEvents: (ignore, options) => {
    ipcRenderer.send('set-ignore-mouse-events', ignore, options);
  },
  setAlwaysOnTop: (flag) => ipcRenderer.invoke('set-always-on-top', flag),
  onToggleIslandState: (callback) => {
    ipcRenderer.on('toggle-island-state', () => callback());
  },

  // Media
  getCurrentTrack: () => ipcRenderer.invoke('get-current-track'),
  controlMedia: (action) => ipcRenderer.invoke('media-control', action),

  // System & Telemetry
  getMetrics: () => ipcRenderer.invoke('get-system-metrics'),
  setVolume: (level) => ipcRenderer.invoke('set-volume', level),
  toggleMute: () => ipcRenderer.invoke('toggle-mute'),
  getInstalledApps: () => ipcRenderer.invoke('get-installed-apps'),
  launchApp: (appPath) => ipcRenderer.invoke('launch-app', appPath),
  searchFiles: (query) => ipcRenderer.invoke('search-files', query),
  openFile: (filePath) => ipcRenderer.invoke('open-file', filePath),
  setWallpaper: (filePath) => ipcRenderer.invoke('set-wallpaper', filePath),
  readClipboard: () => ipcRenderer.invoke('read-clipboard'),
  writeClipboard: (text) => ipcRenderer.invoke('write-clipboard', text),

  // Configuration
  getConfig: () => ipcRenderer.invoke('get-config'),
  setConfig: (key, val) => ipcRenderer.invoke('set-config', key, val),
});
