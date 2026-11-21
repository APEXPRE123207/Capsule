const { ipcMain } = require('electron');
const { exec } = require('child_process');

class MediaManager {
  constructor() {
    this.currentTrack = {
      title: 'Starboy (feat. Daft Punk)',
      artist: 'The Weeknd',
      album: 'Starboy',
      duration: 230,
      position: 84,
      isPlaying: true,
      source: 'Spotify',
    };
    this.setupIpc();
  }

  setupIpc() {
    ipcMain.handle('get-current-track', async () => {
      await this.detectMedia();
      return this.currentTrack;
    });

    ipcMain.handle('media-control', (event, action) => {
      this.executeMediaControl(action);
      return true;
    });
  }

  async detectMedia() {
    return new Promise((resolve) => {
      // Check for Spotify process on Windows
      exec('tasklist /FI "IMAGENAME eq Spotify.exe" /FO CSV /NH', (err, stdout) => {
        if (!err && stdout.includes('Spotify.exe')) {
          this.currentTrack.source = 'Spotify';
        }
        resolve(this.currentTrack);
      });
    });
  }

  executeMediaControl(action) {
    if (action === 'playPause') {
      this.currentTrack.isPlaying = !this.currentTrack.isPlaying;
      this.sendMediaKey(0xB3); // VK_MEDIA_PLAY_PAUSE
    } else if (action === 'next') {
      this.sendMediaKey(0xB0); // VK_MEDIA_NEXT_TRACK
    } else if (action === 'prev') {
      this.sendMediaKey(0xB1); // VK_MEDIA_PREV_TRACK
    }
  }

  sendMediaKey(vkCode) {
    // Use PowerShell to dispatch standard Windows virtual key code for media
    const script = `Add-Type -TypeDefinition '[DllImport("user32.dll")] public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, int dwExtraInfo);' -Name Keybd -Namespace User32; [User32.Keybd]::keybd_event(${vkCode}, 0, 0, 0); [User32.Keybd]::keybd_event(${vkCode}, 0, 2, 0);`;
    exec(`powershell -NoProfile -Command "${script}"`, () => {});
  }
}

module.exports = new MediaManager();
