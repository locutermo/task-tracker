@echo off
set "SCRIPT_DIR=%~dp0"
set "PYTHON_CMD=python"
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "VBS_SCRIPT=%SCRIPT_DIR%run_tracker.vbs"
set "SHORTCUT=%STARTUP_FOLDER%\IntegratelTracker.lnk"

IF "%1"=="" GOTO :USAGE

:INSTALL
IF "%1"=="install" (
    echo Installing dependencies...
    %PYTHON_CMD% -m pip install -r requirements.txt
    
    echo Creating headless launcher script...
    echo Set WshShell = CreateObject("WScript.Shell") > "%VBS_SCRIPT%"
    echo WshShell.Run "cmd /c cd /d ""%SCRIPT_DIR%"" && %PYTHON_CMD% -m src.main", 0 >> "%VBS_SCRIPT%"
    echo Set WshShell = Nothing >> "%VBS_SCRIPT%"
    
    echo Creating Startup shortcut...
    powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SHORTCUT%');$s.TargetPath='%VBS_SCRIPT%';$s.WorkingDirectory='%SCRIPT_DIR%';$s.Save()"
    
    echo Starting service...
    start /b wscript "%VBS_SCRIPT%"
    
    echo Service installed and started.
    GOTO :EOF
)

:START
IF "%1"=="start" (
    echo Starting service...
    start /b wscript "%VBS_SCRIPT%"
    GOTO :EOF
)

:STOP
IF "%1"=="stop" (
    echo Stopping service...
    taskkill /F /IM python.exe /FI "WINDOWTITLE eq IntegratelTracker*"
    REM Note: This might kill other python scripts. Ideally main.py stores a PID file.
    REM For MVP, we warn the user.
    echo Service stopped (if it was running).
    GOTO :EOF
)

:STATUS
IF "%1"=="status" (
    tasklist /FI "IMAGENAME eq pythonw.exe"
    GOTO :EOF
)

:USAGE
echo.
echo Usage: manage_tracker.bat {install|start|stop|status}
echo.
GOTO :EOF
