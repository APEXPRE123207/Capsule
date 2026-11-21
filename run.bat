@echo off
set "PATH=W:\CODE\NodeJS;%PATH%"
set "ELECTRON_RUN_AS_NODE="
cd /d "%~dp0capsule"
node scripts\start.js
