## Características Principales

*   **Rastreo Silencioso**: Funciona en segundo plano sin interrumpir.
*   **Detección de Inactividad**: Pausa el rastreo si no hay movimiento de mouse/teclado por 2 minutos.
*   **Modo Reunión Inteligente**: Detecta automáticamente si estás en una reunión (Webex, Zoom, Teams, Meet) y **mantiene el estado Activo** aunque no muevas el mouse.
*   **Reportes Granulares**: Agrupa la actividad por Aplicación y Título de Ventana.
*   **Historial Exportable**: Genera archivos `.log` detallados con formato de tabla.
*   **Servicio Automático**: Se inicia automáticamente al encender la Mac.

## 📦 Distribución Standalone (Sin Python)

**Opción A: Descargar desde GitHub (Recomendado)**
Este proyecto usa **GitHub Actions**. Al subir cambios al repositorio, se generan automáticamente los ejecutables.
1.  Ve a la pestaña "Actions" en tu repositorio de GitHub.
2.  Entra a la última ejecución ("Build Standalone Executables").
3.  Abajo en "Artifacts", descarga de la sección de instaladores.
4.  Para Windows busca `Instalador-Windows` y para Mac `Instalador-Mac-PKG`.

**Opción B: Compilar Manualmente (Local)**
Si prefieres hacerlo en tu máquina:

**Mac:**
```bash
./scripts/build/build_installer_macos.sh
```
Genera: `tracker_installer.pkg`

**Windows (Requiere [Inno Setup](https://jrsoftware.org/isdl.php)):**
```cmd
scripts\build\build_installer_windows.bat
```
Genera: `Output\InstaladorTracker.exe`

## Instalación (Desarrollo)

1.  Asegúrate de tener Python 3.11 instalado.
2.  Instala las dependencias:
    ```bash
    pip3 install -r requirements.txt
    ```
3.  **Permisos**: Al ejecutarlo por primera vez, macOS pedirá permisos de **Accesibilidad**. Debes concederlos para que `pynput` pueda detectar la inactividad.

## Uso Manual

El punto de entrada principal es el módulo `src.main`.

*   **Ver Gráfico del Día**:
    ```bash
    python3 -m src.main --plot
    ```
*   **Exportar Historial Completo a Log**:
    ```bash
    python3 -m src.main --export mi_reporte.log
    ```
*   **Limpiar Base de Datos**:
    ```bash
    python3 -m src.main --clear
    ```

## Ejecución en macOS (Daemon)

El proyecto incluye un script de gestión `manage_tracker.sh` para controlar el servicio en segundo plano.

### Comandos de Gestión (Mac)
*   **Instalar**: `./scripts/macos/manage_tracker.sh install`
*   **Estado**: `./scripts/macos/manage_tracker.sh status`  
*   **Detener**: `./scripts/macos/manage_tracker.sh stop`

## Ejecución en Windows

El proyecto incluye `manage_tracker.bat` para facilitar la instalación y auto-inicio.

### Comandos de Gestión (Windows)
1.  Abre una terminal (CMD o PowerShell) en la carpeta del proyecto.
2.  **Instalar y Arrancar**:
    ```cmd
    scripts\windows\manage_tracker.bat install
    ```
3.  **Ver Estado**:
    ```cmd
    scripts\windows\manage_tracker.bat status
    ```
4.  **Detener**:
    ```cmd
    scripts\windows\manage_tracker.bat stop
    ```

## Estructura del Proyecto

```
tracker/
├── dist/                         # Carpeta CRÍTICA: Contiene el ejecutable del programa
├── src/                          # Código fuente (Solo para desarrolladores)
├── scripts/                      # Scripts técnicos (Solo para desarrolladores)
│   ├── build/                    # Scripts para construir el ejecutable
│   ├── macos/                    # Scripts internos de Mac
│   └── windows/                  # Scripts internos de Windows
├── Instalar.bat                  # [PARA ABOGADOS WINDOWS] Doble click para instalar
├── Instalar.command              # [PARA ABOGADOS MAC] Doble click para instalar
├── Generar Reporte.bat           # [PARA ABOGADOS WINDOWS] Doble click para ver reporte
├── Generar Reporte.command       # [PARA ABOGADOS MAC] Doble click para ver reporte
└── README.md
```

## 👩‍⚖️ Instrucciones para el usuario final (Abogados)

El abogado podrá descargar directamente los instaladores desde la pestaña **Actions** de GitHub (archivos `.exe` y `.pkg`).

### En Windows 🪟
1.  Descarga y ejecuta `InstaladorTracker.exe`.
2.  Sigue los pasos. El tracker se configurará para iniciar automáticamente.
3.  **Para ver el reporte**: Busca el icono **"Generar Reporte Tracker"** en tu **Escritorio** o Menú Inicio. Al abrirlo, se generará el log y se abrirá automáticamente.

### En Mac 🍎
1.  Descarga y ejecuta `tracker_installer.pkg`.
2.  ⚠️ **Aviso de Seguridad**: Al ser software privado, Mac mostrará un aviso. Para instalarlo:
    *   **Click derecho** (o Control + Click) sobre el instalador y selecciona **Abrir**.
3.  Una vez instalado, el servicio correrá en segundo plano automáticamente.
4.  **Para ver el reporte**: Ve a tu carpeta de **Aplicaciones**, busca la carpeta **Tracker** y abre el archivo **"Generar Reporte"**.