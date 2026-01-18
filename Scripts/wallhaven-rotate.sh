#Wallhaven with Waypaper is a great way to automatically pull high-quality wallpapers without manually downloading them. Let’s break it down carefully for your Arch + Hyprland setup.

#!/bin/bash

# Set Waypaper backend for Hyprland
export WAYPAPER_BACKEND=hyprpaper

# Tags and options
TAGS="sci-fi,lofi,cyberpunk"
PURITY="sfw"
RESOLUTION="2560x1440"   # change to your monitor resolution
INTERVAL=600              # wallpaper change interval in seconds

# Loop to fetch wallpapers
while true; do
    # Detect number of monitors
    SCREENS=$(hyprctl monitors -j | jq '. | length')

    # Fetch random wallpapers for all screens
    waypaper wallhaven random --tags "$TAGS" --purity "$PURITY" --resolution "$RESOLUTION" --screens "$SCREENS"

    # Wait before fetching the next wallpaper
    sleep $INTERVAL
done



