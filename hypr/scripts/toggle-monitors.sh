#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------
# Configuration
# --------------------------------------------------

STATE_FILE="$HOME/.config/hypr/monitor_state"
WALL_SCRIPT="$HOME/.config/hypr/scripts/apply-wallpapers.sh"

# Monitor layout definitions
TV_MONITOR="HDMI-A-2"

MON_LEFT="DP-2"
MON_CENTER="HDMI-A-1"
MON_RIGHT="DP-1"

# --------------------------------------------------
# Detect current state
# --------------------------------------------------

STATE="$(cat "$STATE_FILE" 2>/dev/null || echo "multi")"

# --------------------------------------------------
# Helper functions
# --------------------------------------------------

kill_all_windows() {
    hyprctl clients -j | jq -r '.[].address' | while read -r addr; do
        hyprctl dispatch closewindow "address:$addr"
    done
}

cleanup_workspaces() {

    # Move to workspace 1 first
    hyprctl dispatch workspace 1
    sleep 0.2

    # Remove extra workspaces
    hyprctl workspaces -j | jq -r '.[].id' | while read -r ws; do
        if [[ "$ws" != "1" ]]; then
            hyprctl dispatch moveworkspacetomonitor "$ws" current 2>/dev/null || true
            hyprctl dispatch workspace "$ws" 2>/dev/null || true
            hyprctl dispatch workspace 1
        fi
    done
}

# --------------------------------------------------
# Switch monitor layout
# --------------------------------------------------

if [[ "$STATE" == "multi" ]]; then

    echo "Switching to single TV monitor..."

    # Cleanup environment
    kill_all_windows
    sleep 0.3
    cleanup_workspaces
    sleep 0.3

    # Disable desktop monitors
    hyprctl keyword monitor "$MON_LEFT,disable"
    hyprctl keyword monitor "$MON_RIGHT,disable"
    hyprctl keyword monitor "$MON_CENTER,disable"

    sleep 0.5

    # Enable TV in 4K
    hyprctl keyword monitor "$TV_MONITOR,3840x2160@60,0x0,2"

    sleep 0.5

    # Ensure workspace 1 is active
    hyprctl dispatch workspace 1

    echo "single" > "$STATE_FILE"

else

    echo "Switching to triple-monitor setup..."

    # Cleanup environment
    kill_all_windows
    sleep 0.3
    cleanup_workspaces
    sleep 0.3

    # Disable TV
    hyprctl keyword monitor "$TV_MONITOR,disable"

    sleep 0.3

    # Enable desktop monitors
    hyprctl keyword monitor "$MON_CENTER,1920x1080@60,0x0,1"
    hyprctl keyword monitor "$MON_LEFT,1920x1080@144,-1920x0,1"
    hyprctl keyword monitor "$MON_RIGHT,1920x1080@60,1920x0,1"

    sleep 0.5

    # Reapply layout (HDMI reliability workaround)
    hyprctl keyword monitor "$MON_CENTER,1920x1080@60,0x0,1"
    hyprctl keyword monitor "$MON_LEFT,1920x1080@144,-1920x0,1"
    hyprctl keyword monitor "$MON_RIGHT,1920x1080@60,1920x0,1"

    sleep 0.3

    # Restore workspaces
    hyprctl dispatch workspace 2
    hyprctl dispatch workspace 3
    hyprctl dispatch workspace 1

    echo "multi" > "$STATE_FILE"

fi

# --------------------------------------------------
# Reapply wallpapers
# --------------------------------------------------

sleep 0.5

if [[ -x "$WALL_SCRIPT" ]]; then
    "$WALL_SCRIPT" &
fi
