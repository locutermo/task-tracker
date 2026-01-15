#!/bin/bash

PLIST_NAME="com.integratel.tracker.plist"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME"
CURRENT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCE_PLIST="$CURRENT_DIR/scripts/macos/$PLIST_NAME"

case "$1" in
    install)
        echo "Installing service..."
        # Create LaunchAgents directory if it doesn't exist
        mkdir -p "$HOME/Library/LaunchAgents"
        
        if [ ! -f "$SOURCE_PLIST" ]; then
            echo "Error: $PLIST_NAME not found in current directory."
            exit 1
        fi
        
        cp "$SOURCE_PLIST" "$PLIST_PATH"
        
        # Unload first just in case it was already loaded
        launchctl unload "$PLIST_PATH" 2>/dev/null
        launchctl load "$PLIST_PATH"
        
        echo "Service installed and started. Logs at /tmp/integratel_tracker.out"
        ;;
    start)
        launchctl load "$PLIST_PATH"
        echo "Service started."
        ;;
    stop)
        launchctl unload "$PLIST_PATH"
        echo "Service stopped."
        ;;
    restart)
        launchctl unload "$PLIST_PATH"
        launchctl load "$PLIST_PATH"
        echo "Service restarted."
        ;;
    status)
        if launchctl list | grep -q "com.integratel.tracker"; then
            echo "Service is RUNNING"
            echo "--- Recent Logs ---"
            tail -n 5 /tmp/integratel_tracker.out
        else
            echo "Service is STOPPED"
        fi
        ;;
    uninstall)
        launchctl unload "$PLIST_PATH"
        rm "$PLIST_PATH"
        echo "Service uninstalled."
        ;;
    *)
        echo "Usage: $0 {install|start|stop|restart|status|uninstall}"
        exit 1
        ;;
esac
