#!/bin/bash
# Script amigable para doble click en Mac
cd "$(dirname "$0")"

echo "Instalando Tracker..."
./scripts/macos/manage_tracker.sh install

echo ""
echo "✅ Instalación completada."
echo "El tracker ahora corre en segundo plano."
echo "Puedes cerrar esta ventana."
read -p "Presiona Enter para salir..."
