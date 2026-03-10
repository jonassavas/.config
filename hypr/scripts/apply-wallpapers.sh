#!/usr/bin/env bash

WALLDIR="$HOME/.config/hypr/wallpapers"

# start swww if not running
pgrep -x swww-daemon >/dev/null || swww-daemon
swww query >/dev/null || swww init

# get enabled monitors
mapfile -t MONITORS < <(hyprctl monitors -j | jq -r '.[].name')

MONITOR_COUNT=${#MONITORS[@]}

# pick random theme directory
mapfile -t DIRS < <(find "$WALLDIR" -mindepth 1 -maxdepth 1 -type d)

RANDOM_DIR="${DIRS[$RANDOM % ${#DIRS[@]}]}"

# get wallpapers in directory
mapfile -t WALLPAPERS < <(find "$RANDOM_DIR" -type f)

WALL_COUNT=${#WALLPAPERS[@]}

# shuffle wallpapers
SHUFFLED=($(printf "%s\n" "${WALLPAPERS[@]}" | shuf))

# apply wallpapers
for i in "${!MONITORS[@]}"; do

    if (( WALL_COUNT >= MONITOR_COUNT )); then
        # enough wallpapers -> unique selection
        WP="${SHUFFLED[$i]}"
    else
        # not enough -> allow duplicates
        WP="${WALLPAPERS[$RANDOM % WALL_COUNT]}"
    fi

    swww img "$WP" --outputs "${MONITORS[$i]}"
done
