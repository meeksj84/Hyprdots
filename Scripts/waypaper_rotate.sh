#!/bin/bash

# Optional: set the backend once for all Waypaper commands
export WAYPAPER_BACKEND=hyprpaper

while true; do
  # Pick a random wallpaper from your folder
  FILE=$(find /home/morbo/Hyprdots/Wallpapers -type f | shuf -n1)

  # Set the wallpaper using Waypaper (backend is now automatic)
  waypaper "$FILE"

  # Wait 5 minutes before changing again
  sleep 300
done

/home/morbo/Hyprdots/Scripts/wallpaper-wrapper.sh	

