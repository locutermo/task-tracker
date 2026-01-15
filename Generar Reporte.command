#!/bin/bash
# Script amigable para generar reporte
cd "$(dirname "$0")"

echo "Generando reporte de actividad..."
# Usa el binario si existe, sino python
if [ -f "dist/tracker" ]; then
    ./dist/tracker --export "Reporte_Abogados.log"
else
    # Fallback dev mode
    /usr/local/bin/python3.11 -m src.main --export "Reporte_Abogados.log"
fi

echo ""
echo "✅ Reporte generado: Reporte_Abogados.log"
echo "Abriendo archivo..."
open "Reporte_Abogados.log"
