#!/usr/bin/env bash
set -euo pipefail
# --------------------------------------------------
# Configuration
# --------------------------------------------------
STATE_FILE="$HOME/.config/hypr/monitor_state"
WALL_SCRIPT="$HOME/.config/hypr/scripts/apply-wallpapers.sh"
MONITOR="HDMI-A-2"
# Define resolutions as variables for easy tweaking
RES_4K="3840x2160@60,0x0,2"
RES_1440="2560x1440@120,0x0,1.25"
# --------------------------------------------------
# Verify TV mode is active
# --------------------------------------------------
STATE="$(cat "$STATE_FILE" 2>/dev/null || echo "multi")"
if [[ "$STATE" != "single" ]]; then
    echo "TV mode is not active."
    exit 0
fi
# --------------------------------------------------
# Detect current resolution
# --------------------------------------------------
WIDTH="$(hyprctl monitors -j | jq -r \
'.[] | select(.name=="'"$MONITOR"'") | .width')"
if [[ -z "$WIDTH" || "$WIDTH" == "null" ]]; then
    echo "Monitor $MONITOR not active."
    exit 1
fi
# --------------------------------------------------
# Determine target resolution
# --------------------------------------------------
if [[ "$WIDTH" == "3840" ]]; then
    echo "Switching to 1440p 120Hz"
    TARGET_RES="$RES_1440"
    NEEDS_RESET=false
else
    echo "Switching to 4K 60Hz — disabling monitor to force fresh HDMI negotiation"
    TARGET_RES="$RES_4K"
    NEEDS_RESET=true
fi
# --------------------------------------------------
# Apply the target resolution
# --------------------------------------------------
if [[ "$NEEDS_RESET" == true ]]; then
    hyprctl keyword monitor "$MONITOR,disable"
    sleep 2
    hyprctl keyword monitor "$MONITOR,$TARGET_RES"
else
    hyprctl keyword monitor "$MONITOR,$TARGET_RES"
fi
# --------------------------------------------------
# Allow Hyprland to settle
# --------------------------------------------------
sleep 0.5
# --------------------------------------------------
# Reapply wallpapers
# --------------------------------------------------
if [[ -x "$WALL_SCRIPT" ]]; then
    "$WALL_SCRIPT" &
fi
