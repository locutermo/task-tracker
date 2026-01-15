## Características Principales

*   **Rastreo Silencioso**: Funciona en segundo plano sin interrumpir.
*   **Detección de Inactividad**: Pausa el rastreo si no hay movimiento de mouse/teclado por 2 minutos.
*   **Modo Reunión Inteligente**: Detecta automáticamente si estás en una reunión (Webex, Zoom, Teams, Meet) y **mantiene el estado Activo** aunque no muevas el mouse.
*   **Reportes Granulares**: Agrupa la actividad por Aplicación y Título de Ventana.
*   **Historial Exportable**: Genera archivos `.log` detallados con formato de tabla.
*   **Servicio Automático**: Se inicia automáticamente al encender la Mac.

## Instalación

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
├── src/                          # Código fuente modular
│   ├── __init__.py
│   ├── config.py                 # Configuración
│   ├── database.py               # Manejador de base de datos
│   ├── idle_detector.py          # Detección de inactividad
│   ├── tracker.py                # Lógica principal de rastreo
│   ├── visualizer.py             # Reportes y gráficos
│   └── main.py                   # Punto de entrada
├── scripts/                      # Scripts de gestión por plataforma
│   ├── macos/
│   │   ├── manage_tracker.sh
│   │   └── com.integratel.tracker.plist
│   └── windows/
│       └── manage_tracker.bat
├── requirements.txt
├── README.md
└── timeline_abogados.db          # Base de datos (se genera automáticamente)
```
en la máquina del abogado.

El usuario tiene la potestad de revisar y filtrar qué información se enviará finalmente a los sistemas corporativos (Jira).