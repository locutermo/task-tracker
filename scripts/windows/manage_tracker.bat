@echo off
set "SCRIPT_DIR=%~dp0"
set "PYTHON_CMD=python"
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "VBS_SCRIPT=%SCRIPT_DIR%run_tracker.vbs"
set "SHORTCUT=%STARTUP_FOLDER%\IntegratelTracker.lnk"

IF "%1"=="" GOTO :USAGE

:INSTALL
:INSTALL
IF "%1"=="install" (
    echo Installing service...
    
    REM Check if we are in dist/ folder deployment or source
    REM Assuming we deploy the whole folder structure or just the bin?
    REM Let's assume the user unzips the build folder which has scripts/ and dist/
    
    IF NOT EXIST "%SCRIPT_DIR%..\..\dist\tracker.exe" (
        echo Error: tracker.exe not found in dist folder.
        echo Please ensure you have built the project or downloaded the full release.
        GOTO :EOF
    )

    echo Creating headed launcher script...
    echo Set WshShell = CreateObject("WScript.Shell") > "%VBS_SCRIPT%"
    echo WshShell.Run chr(34) ^& "%SCRIPT_DIR%..\..\dist\tracker.exe" ^& chr(34), 0 >> "%VBS_SCRIPT%"
    echo Set WshShell = Nothing >> "%VBS_SCRIPT%"
    
    echo Creating Startup shortcut...
    powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SHORTCUT%');$s.TargetPath='%VBS_SCRIPT%';$s.WorkingDirectory='%SCRIPT_DIR%..\..\dist';$s.Save()"
    
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
