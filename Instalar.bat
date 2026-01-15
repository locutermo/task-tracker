@echo off
cd /d "%~dp0"
echo Instalando Tracker...
call scripts\windows\manage_tracker.bat install
pause
