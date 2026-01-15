@echo off
echo Building Windows standalone executable...

REM Clean previous builds
rmdir /s /q build dist

REM Ensure we are in project root (assuming script is in scripts/build/)
cd /d "%~dp0..\.."

REM Run PyInstaller
REM --noconsole: Don't show terminal window
REM --onefile: Bundle everything into a single file
REM --name: Name of the executable
pyinstaller --noconsole --onefile --name tracker launcher.py

echo Build complete. Executable is in dist\tracker.exe
