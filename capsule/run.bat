@echo off
set "PATH=W:\CODE\NodeJS;%PATH%"
set "ELECTRON_RUN_AS_NODE="
cd /d "%~dp0"
node scripts\start.js
