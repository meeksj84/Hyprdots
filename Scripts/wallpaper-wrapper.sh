#!/bin/bash
# Wallpaper wrapper for Waypaper + Hyprpaper

# Folder containing your wallpapers
WALLPAPER_DIR="/home/morbo/Hyprdots/Wallpapers"

# Pick a random wallpaper
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | shuf -n 1)

# Apply wallpaper using Waypaper with hyprpaper backend
waypaper --wallpaper "$RANDOM_WALLPAPER" --backend hyprpaper --monitor All

# Optional: run additional scripts after wallpaper is applied
# Example:
# /home/morbo/Hyprdots/Scripts/script1.sh
# /home/morbo/Hyprdots/Scripts/script2.sh

# Logging (optional, for debugging)
echo "Applied $RANDOM_WALLPAPER at $(date)" >> /home/morbo/wallpaper.log
