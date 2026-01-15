#!/bin/bash
# Script para crear el instalador .pkg en Mac (Usado por GitHub Actions)

# Crear estructura de carpetas simulando el sistema de archivos
mkdir -p build_pkg/usr/local/bin
mkdir -p build_pkg/Library/LaunchAgents

# Copiar el binario
cp dist/tracker build_pkg/usr/local/bin/

# Crear el plist directamente en la ruta correcta
cat > build_pkg/Library/LaunchAgents/com.integratel.tracker.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.integratel.tracker</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/tracker</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/integratel_tracker.out</string>
    <key>StandardErrorPath</key>
    <string>/tmp/integratel_tracker.err</string>
</dict>
</plist>
EOF

# Crear la carpeta de aplicaciones para el reporte
mkdir -p build_pkg/Applications/Tracker
cat > build_pkg/Applications/Tracker/"Generar Reporte.command" <<EOF
#!/bin/bash
cd "\$(dirname "\$0")"
echo "Generando reporte de actividad..."
/usr/local/bin/tracker --export "Reporte_Abogados.log"
echo "✅ Reporte generado: Reporte_Abogados.log"
open "Reporte_Abogados.log"
EOF
chmod +x build_pkg/Applications/Tracker/"Generar Reporte.command"

# Crear el paquete
pkgbuild --root build_pkg \
         --identifier com.integratel.tracker \
         --version 1.0 \
         --install-location / \
         tracker_installer.pkg

echo "Paquete creado: tracker_installer.pkg"
