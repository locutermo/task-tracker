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
3.  Abajo en "Artifacts", descarga `tracker-windows` o `tracker-macos`.
4.  Coloca el archivo descargado en la carpeta `dist/` del proyecto antes de enviarlo.

**Opción B: Compilar Manualmente**
Si prefieres hacerlo en tu máquina:
1.  **Construir**: Ejecutar `./scripts/build/build_macos.sh` (Mac) o `scripts\build\build_windows.bat` (Windows).
2.  **Entregar**: Copiar la carpeta del proyecto con la carpeta `dist/` generada.
3.  **Instalar**: El usuario ejecuta `scripts/macos/manage_tracker.sh install` o `manage_tracker.bat install`. **No requiere instalar Python.**

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
    *(Esto instala dependencias y crea un acceso directo en `Inicio` para que arranque al prender la PC)*.
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
en la máquina del abogado.

El usuario tiene la potestad de revisar y filtrar qué información se enviará finalmente a los sistemas corporativos (Jira).