#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------
# Configuration
# --------------------------------------------------
WALL_SCRIPT="$HOME/.config/hypr/scripts/apply-wallpapers.sh"
TV_MONITOR="HDMI-A-2"

# Monitor layout positions
# Assuming TV is above the center monitor
MON_LEFT="DP-2"
MON_CENTER="HDMI-A-1"
MON_RIGHT="DP-1"

TV_POS="0x-2160"    # example: TV sits above center monitor; adjust if needed
TV_SCALE="2"        # 4K scaling
TV_RES="3840x2160@60"

# --------------------------------------------------
# Helper functions
# --------------------------------------------------
kill_windows_on_monitor() {
    local MON="$1"
    hyprctl clients -j | jq -r '.[] | select(.monitor=="'"$MON"'") | .address' | while read -r addr; do
        hyprctl dispatch closewindow "address:$addr"
    done
}

cleanup_workspaces_on_monitor() {
    local MON="$1"
    # Move any workspaces from this monitor to current workspace
    hyprctl workspaces -j | jq -r '.[] | select(.monitor=="'"$MON"'") | .id' | while read -r ws; do
        hyprctl dispatch moveworkspacetomonitor "$ws" current 2>/dev/null || true
        hyprctl dispatch workspace "$ws" 2>/dev/null || true
        hyprctl dispatch workspace 1
    done
}

# --------------------------------------------------
# Check if TV monitor is currently enabled
# --------------------------------------------------
TV_ENABLED=$(hyprctl monitors -j | jq -r '.[] | select(.name=="'"$TV_MONITOR"'") | .name // empty')

if [[ -n "$TV_ENABLED" ]]; then
    echo "Disabling TV monitor ($TV_MONITOR)..."

    # Kill windows on TV and cleanup workspaces
    kill_windows_on_monitor "$TV_MONITOR"
    sleep 0.2
    cleanup_workspaces_on_monitor "$TV_MONITOR"
    sleep 0.2

    # Disable TV
    hyprctl keyword monitor "$TV_MONITOR,disable"
else
    echo "Enabling TV monitor ($TV_MONITOR) in 4K 60Hz..."

    # Enable TV above other monitors
    hyprctl keyword monitor "$TV_MONITOR,$TV_RES,$TV_POS,$TV_SCALE"

    # Optional: ensure workspace 1 is active
    hyprctl dispatch workspace 1
fi

# --------------------------------------------------
# Reapply wallpapers
# --------------------------------------------------
sleep 0.5
if [[ -x "$WALL_SCRIPT" ]]; then
    "$WALL_SCRIPT" &
fi
