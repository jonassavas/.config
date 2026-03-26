#!/usr/bin/env bash

set -euo pipefail

WALLDIR="$HOME/.config/hypr/wallpapers"

# --- Start awww daemon if not running ---
if ! pgrep -x awww-daemon >/dev/null; then
    awww-daemon &
fi

# --- Wait until swww is ready ---
while ! awww query >/dev/null 2>&1; do
    sleep 0.1
done

# --- Wait until Hyprland monitors are available ---
while [ "$(hyprctl monitors -j | jq length)" -eq 0 ]; do
    sleep 0.1
done

# --- Get enabled monitors ---
mapfile -t MONITORS < <(hyprctl monitors -j | jq -r '.[].name')
MONITOR_COUNT=${#MONITORS[@]}

(( MONITOR_COUNT == 0 )) && exit 1

# --- Get theme directories ---
mapfile -t DIRS < <(find "$WALLDIR" -mindepth 1 -maxdepth 1 -type d)

(( ${#DIRS[@]} == 0 )) && exit 1

# --- Pick random theme ---
RANDOM_DIR="${DIRS[RANDOM % ${#DIRS[@]}]}"

# --- Get wallpapers (filtered image types) ---
mapfile -t WALLPAPERS < <(find "$RANDOM_DIR" -type f \( \
    -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.webp" \
\))

WALL_COUNT=${#WALLPAPERS[@]}

(( WALL_COUNT == 0 )) && exit 1

# --- Shuffle wallpapers safely ---
mapfile -t SHUFFLED < <(printf "%s\n" "${WALLPAPERS[@]}" | shuf)

# --- Apply wallpapers per monitor ---
for i in "${!MONITORS[@]}"; do

    if (( WALL_COUNT >= MONITOR_COUNT )); then
        WP="${SHUFFLED[$i]}"
    else
        WP="${WALLPAPERS[RANDOM % WALL_COUNT]}"
    fi

    awww img "$WP" \
        --outputs "${MONITORS[$i]}" \
        --transition-type none

done
