const { spawn } = require('child_process');
const path = require('path');

// Ensure ELECTRON_RUN_AS_NODE does not prevent Electron from launching the GUI app
delete process.env.ELECTRON_RUN_AS_NODE;
const cleanEnv = { ...process.env };
delete cleanEnv.ELECTRON_RUN_AS_NODE;

const electronExe = path.join(__dirname, '../node_modules/electron/dist/electron.exe');
const appRoot = path.join(__dirname, '..');

const child = spawn(electronExe, [appRoot], {
  stdio: 'inherit',
  env: cleanEnv,
  windowsHide: false,
});

child.on('exit', (code) => {
  process.exit(code || 0);
});
