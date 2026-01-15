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
        
        # Verify binary exists
        BINARY_PATH="$CURRENT_DIR/dist/tracker"
        if [ ! -f "$BINARY_PATH" ]; then
             # If binary doesn't exist, fallback to Python or error?
             # Let's try to identify if we are in dev or prod.
             # Ideally we assume binary exists if we are in 'standalone' mode.
             # But let's check relative to the script location.
             # The script is in scripts/macos/, so root is ../../
             BINARY_PATH="$CURRENT_DIR/../../dist/tracker"
        fi

        if [ ! -f "$BINARY_PATH" ]; then
            echo "Error: Binary not found at $BINARY_PATH. Did you run build_macos.sh?"
            exit 1
        fi
        
        # Generate custom plist with absolute path to binary
        cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.integratel.tracker</string>
    <key>ProgramArguments</key>
    <array>
        <string>$BINARY_PATH</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/integratel_tracker.out</string>
    <key>StandardErrorPath</key>
    <string>/tmp/integratel_tracker.err</string>
    <key>WorkingDirectory</key>
    <string>$(dirname "$BINARY_PATH")</string>
</dict>
</plist>
EOF
        
        echo "Generated $PLIST_PATH"
        
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
