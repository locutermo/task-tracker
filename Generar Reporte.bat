@echo off
cd /d "%~dp0"
echo Generando reporte...

IF EXIST "tracker.exe" (
    tracker.exe --export "Reporte_Abogados.log"
) ELSE IF EXIST "dist\tracker.exe" (
    dist\tracker.exe --export "Reporte_Abogados.log"
) ELSE (
    python -m src.main --export "Reporte_Abogados.log"
)

echo.
echo Reporte generado: Reporte_Abogados.log
echo Abriendo...
start Reporte_Abogados.log
pause
