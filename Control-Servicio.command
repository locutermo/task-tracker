#!/bin/bash
# Script de Gestión para el Tracker (macOS)
# Este script te permite controlar la versión instalada o correr el código localmente.

echo "=========================================="
echo "   CONTROL DE SERVICIO TRACKER - MAC      "
echo "=========================================="

SERVICE_LABEL="com.integratel.tracker"
PLIST_PATH="/Library/LaunchAgents/${SERVICE_LABEL}.plist"

menu() {
    echo ""
    echo "1) Ver estado del servicio (instalado)"
    echo "2) Detener servicio (Stop)"
    echo "3) Iniciar/Reiniciar servicio (Start)"
    echo "4) Ver LOGS en vivo"
    echo "5) Ejecutar código localmente (Para pruebas)"
    echo "6) Salir"
    echo ""
    read -p "Selecciona una opción: " opcion

    case $opcion in
        1)
            launchctl list | grep $SERVICE_LABEL
            if [ $? -eq 0 ]; then
                echo "✅ El servicio está cargado."
            else
                echo "❌ El servicio NO está cargado (posiblemente detenido)."
            fi
            menu
            ;;
        2)
            echo "Deteniendo servicio..."
            # Intentar el comando moderno primero
            launchctl bootout gui/$(id -u) "$PLIST_PATH" 2>/dev/null
            # Fallback al comando antiguo si el anterior falla
            launchctl unload "$PLIST_PATH" 2>/dev/null
            
            # Verificar si sigue vivo y forzar salida si es necesario
            PID=$(launchctl list | grep "$SERVICE_LABEL" | awk '{print $1}')
            if [ "$PID" != "-" ] && [ ! -z "$PID" ]; then
                echo "El servicio no respondió, forzando cierre (PID: $PID)..."
                kill -9 $PID 2>/dev/null
            fi
            echo "Servicio detenido correctamente."
            menu
            ;;
        3)
            echo "Iniciando servicio..."
            launchctl bootstrap gui/$(id -u) "$PLIST_PATH" 2>/dev/null || launchctl load "$PLIST_PATH"
            echo "Servicio iniciado."
            menu
            ;;
        4)
            echo "Mostrando logs (Ctrl+C para salir)..."
            tail -f /tmp/integratel_tracker.out
            ;;
        5)
            echo "Ejecutando código local (Python)..."
            export PYTHONPATH=$PYTHONPATH:.
            python3 launcher.py
            ;;
        6)
            exit 0
            ;;
        *)
            echo "Opción no válida."
            menu
            ;;
    esac
}

menu
