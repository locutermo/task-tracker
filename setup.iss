[Setup]
AppName=Tracker de Actividad
AppVersion=1.0
DefaultDirName={userpf}\TrackerAbogados
DefaultGroupName=Tracker
OutputBaseFilename=InstaladorTracker
Compression=lzma
SolidCompression=yes
PrivilegesRequired=lowest

[Files]
Source: "dist\tracker.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; Crear acceso directo en el Menú Inicio
Name: "{group}\Tracker"; Filename: "{app}\tracker.exe"
; Crear acceso directo en la carpeta de Inicio (Startup) para auto-arranque
Name: "{userstartup}\Tracker"; Filename: "{app}\tracker.exe"; WorkingDir: "{app}"

[Run]
; Ejecutar al finalizar la instalación
Filename: "{app}\tracker.exe"; Description: "Iniciar Tracker ahora"; Flags: nowait postinstall skipifsilent
