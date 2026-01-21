#!/usr/bin/env bash

# Path to store current toggle state
STATE_FILE="$HOME/.config/hypr/monitor_state"

# Read current state (default to "multi")
STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "multi")

if [ "$STATE" = "multi" ]; then
    echo "Switching to single 4K HDMI-A-2 monitor..."

    # Disable all other monitors
    hyprctl keyword monitor "DP-2,disable"
    hyprctl keyword monitor "DP-1,disable"
    hyprctl keyword monitor "HDMI-A-1,disable"
		sleep 0.5 # For monitors to start/stop correctly
    # Enable the 4K TV
    hyprctl keyword monitor "HDMI-A-2,3840x2160@60,0x0,1"
    sleep 0.5 # For monitors to start/stop correctly
    hyprctl dispatch workspace 1
    hyprctl dispatch centerwindow

    echo "single" > "$STATE_FILE"
else
    echo "Switching back to triple-monitor setup..."

    # Disable the TV
    hyprctl keyword monitor "HDMI-A-2,disable"

    # Re-enable the three monitors
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1"
		hyprctl keyword monitor "DP-2,1920x1080@144,-1920x0,1"
    hyprctl keyword monitor "DP-1,1920x1080@60,1920x0,1"
		
		# Reapplying the resolution avoided a bug with the
		# HDMI monitor.
		sleep 0.5
		hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1"
		hyprctl keyword monitor "DP-2,1920x1080@144,-1920x0,1"
    hyprctl keyword monitor "DP-1,1920x1080@60,1920x0,1"

    echo "multi" > "$STATE_FILE"
fi

