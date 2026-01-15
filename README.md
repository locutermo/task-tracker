# ⚖️ Tracker de Actividad - IntegraTel

Sistema automatizado de rastreo de actividad para abogados. El programa corre en segundo plano y detecta actividad basada en la interacción con el teclado/mouse y el estado de reuniones de video.

## 🚀 Distribución y Uso (Abogados)

El proceso de distribución se realiza **únicamente** a través de la pestaña **Actions** de este repositorio.

### 1. Obtener el instalador
1.  Ve a la pestaña **Actions** en GitHub.
2.  Entra en la última ejecución exitosa del workflow "Build Standalone Executables".
3.  En la sección **Artifacts**, descarga:
    *   **Instalador-Windows**: Contiene `InstaladorTracker.exe`.
    *   **Instalador-Mac-PKG**: Contiene `tracker_installer.pkg`.

### 2. Instalación en Windows 🪟
1.  Ejecuta `InstaladorTracker.exe`.
2.  Sigue los pasos ("Siguiente", "Siguiente").
3.  El programa se iniciará solo cada vez que enciendas la PC.
4.  **Ver Reporte**: Haz doble clic en el icono **"Generar Reporte Tracker"** en tu **Escritorio**.

### 3. Instalación en Mac 🍎
1.  Ejecuta `tracker_installer.pkg`.
2.  ⚠️ **Aviso de Seguridad**: Haz **Click derecho** (o Control + Click) sobre el instalador y selecciona **Abrir** para autorizar la instalación privada.
3.  **Ver Reporte**: Ve a la carpeta de **Aplicaciones**, busca la carpeta **Tracker** y abre **"Generar Reporte"**.

---

## 💻 Desarrollo y Mantenimiento

Para desarrolladores que deseen modificar el código:

1.  **Requisitos**: Python 3.11+.
2.  **Instalación**: `pip install -r requirements.txt`.
3.  **Ejecución**: `python -m src.main`.
4.  **Build**: Cualquier cambio subido a la rama `main` (o `installer`) disparará automáticamente la creación de nuevos instaladores en GitHub Actions.

### Estructura
- `src/`: Lógica principal (rastreo, base de datos, visualización).
- `launcher.py`: Punto de entrada para el binario.
- `setup.iss` / `scripts/build/`: Configuraciones de los instaladores.
- `Generar Reporte.bat`: Script base usado en el build de Windows.