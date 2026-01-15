#!/bin/bash
# Build script for macOS
echo "Building macOS standalone executable..."

# Clean previous builds
rm -rf build dist

# Run PyInstaller
# --noconsole: Don't show terminal window
# --onefile: Bundle everything into a single file
# --name: Name of the executable
# --hidden-import: Explicitly import hidden dependencies if needed
# We build 'launcher.py' to preserve the 'src' package structure
# Ensure we are in project root
cd "$(dirname "$0")/../.."

python3 -m PyInstaller --noconsole --onefile --name tracker \
    --add-data "timeline_abogados.db:." \
    launcher.py

echo "Build complete. Executable is in dist/tracker"
