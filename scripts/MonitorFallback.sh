#!/bin/bash

# Log file for debugging
LOG_FILE="/tmp/monitor_fallback.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "--- Script started at $(date) ---"

set -euo pipefail

# Configuration
INTERNAL_MONITOR="eDP-2"
TARGET_CONF="$HOME/.config/hypr/monitors.conf"

# Give the system and Hyprland time to initialize DRM and sockets
echo "Waiting 5 seconds for system to settle..."
sleep 5

# Function to detect ACTUALLY active external monitors
detect_external_monitors() {
    local connector_path
    local connector_name
    local detected=()

    for connector_path in /sys/class/drm/card*-*; do
        [[ -e "$connector_path/status" ]] || continue
        
        local status
        status=$(cat "$connector_path/status" 2>/dev/null)
        connector_name="${connector_path##*/}"
        connector_name="${connector_name#*-}"

        # Ignore internal displays
        case "$connector_name" in
            eDP|eDP-*|LVDS|LVDS-*|DSI|DSI-*)
                continue
                ;;
        esac

        echo "Checking $connector_name: $status"

        if [[ "$status" == "connected" ]]; then
            # Check if there are actual modes (resolutions) available
            # If the monitor is OFF, 'modes' is often empty even if 'status' is connected
            if [[ -s "$connector_path/modes" ]]; then
                echo "Detected ACTIVE external: $connector_name (has valid modes)"
                detected+=("$connector_name")
            else
                echo "Monitor $connector_name is connected but has NO modes (likely powered off). Ignoring."
            fi
        fi
    done

    printf '%s\n' "${detected[@]}"
}

# Main logic
EXTERNAL_MONITORS=$(detect_external_monitors)

if [[ -z "$EXTERNAL_MONITORS" ]]; then
    echo "No ACTIVE external monitors detected."
    
    # Check if internal monitor is disabled in the config
    # We use a very flexible regex to catch various spacing styles
    if grep -iE "monitor\s*=\s*$INTERNAL_MONITOR\s*,\s*disable" "$TARGET_CONF" > /dev/null 2>&1; then
        echo "Internal monitor $INTERNAL_MONITOR is currently disabled in $TARGET_CONF. Re-enabling as fallback."
        
        # Update the config file
        {
            echo "# Managed by MonitorFallback.sh (Fallback Active)"
            echo "# $(date '+%Y-%m-%d %H:%M:%S %Z')"
            echo "monitor=$INTERNAL_MONITOR,preferred,auto,1"
        } > "$TARGET_CONF"
        
        echo "Updated $TARGET_CONF"

        # Apply the change with retry loop for hyprctl
        for i in {1..5}; do
            echo "Attempt $i to enable $INTERNAL_MONITOR via hyprctl..."
            if hyprctl keyword monitor "$INTERNAL_MONITOR,preferred,auto,1" >/dev/null 2>&1; then
                echo "Successfully enabled $INTERNAL_MONITOR"
                break
            fi
            sleep 1
        done
        
        if command -v notify-send >/dev/null; then
            notify-send -u critical -t 10000 "Monitor Fallback" "No active external monitors detected. Laptop screen re-enabled."
        fi
    else
        echo "Internal monitor is already enabled or not found in $TARGET_CONF. No action needed."
    fi
else
    echo "Active external monitors found: $EXTERNAL_MONITORS. Skipping fallback."
fi

echo "--- Script finished at $(date) ---"
