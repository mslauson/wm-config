#!/bin/bash

# Parse the JSON and create a menu with wofi
selection=$(hyprctl clients -j | jq -r '.[] | "\(.workspace.name): \(.class) - \(.title)"' | wofi --show=dmenu -c ~/.config/wofi/openwindows)

# Get the workspace name from the selection
workspace=$(echo "$selection" | cut -d':' -f1)

# Use swaymsg to switch to the selected workspace
hyprctl dispatch workspace "$workspace"

