#!/usr/bin/env bash

STATE_FILE="$HOME/.config/hypr/monitor_state"
STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "multi")

kill_all_windows() {
    hyprctl clients -j | jq -r '.[].address' | while read -r addr; do
        hyprctl dispatch closewindow "address:$addr"
    done
}

cleanup_workspaces() {
    # Move to workspace 1 first
    hyprctl dispatch workspace 1
    sleep 0.2
    
    # Get all workspace IDs and remove all except workspace 1
    hyprctl workspaces -j | jq -r '.[].id' | while read -r ws; do
        if [ "$ws" != "1" ]; then
            # Move any remaining windows to workspace 1, then remove the workspace
            hyprctl dispatch moveworkspacetomonitor "$ws" current 2>/dev/null
            hyprctl dispatch workspace "$ws" 2>/dev/null
            hyprctl dispatch workspace 1
        fi
    done
}

if [ "$STATE" = "multi" ]; then
    echo "Switching to single 4K HDMI-A-2 monitor..."
    
    # Kill windows and clean workspaces first
    kill_all_windows
    sleep 0.3
    cleanup_workspaces
    sleep 0.3
    
    # Disable other monitors
    hyprctl keyword monitor "DP-2,disable"
    hyprctl keyword monitor "DP-1,disable"
    hyprctl keyword monitor "HDMI-A-1,disable"
    sleep 0.5
    
    # Enable TV
    hyprctl keyword monitor "HDMI-A-2,3840x2160@60,0x0,1"
    sleep 0.5
    
    # Ensure we're on workspace 1
    hyprctl dispatch workspace 1
    
    echo "single" > "$STATE_FILE"
else
    echo "Switching back to triple-monitor setup..."
    
    # Kill windows and clean workspaces first
    kill_all_windows
    sleep 0.3
    cleanup_workspaces
    sleep 0.3
    
    # Disable TV
    hyprctl keyword monitor "HDMI-A-2,disable"
    sleep 0.3
    
    # Re-enable monitors
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1"
    hyprctl keyword monitor "DP-2,1920x1080@144,-1920x0,1"
    hyprctl keyword monitor "DP-1,1920x1080@60,1920x0,1"
    
    sleep 0.5
    
    # Reapply (HDMI bug workaround)
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1"
    hyprctl keyword monitor "DP-2,1920x1080@144,-1920x0,1"
    hyprctl keyword monitor "DP-1,1920x1080@60,1920x0,1"
    
    sleep 0.3
    
    # Create workspaces 2 and 3 for the other monitors
    hyprctl dispatch workspace 2
    hyprctl dispatch workspace 3
    hyprctl dispatch workspace 1
    
    echo "multi" > "$STATE_FILE"
fi
