#!/bin/bash

set -e

# Check for flatpak
if ! command -v flatpak &> /dev/null; then
  echo "Flatpak not found. Installing..."
  sudo pacman -S --noconfirm flatpak
fi

# Add Flathub repo if not present
if ! flatpak remote-list | grep -q flathub; then
  echo "Adding Flathub repository..."
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Install Steam via Flatpak
echo "Installing Steam via Flatpak..."
flatpak install -y flathub com.valvesoftware.Steam

echo ""
echo "✅ Steam (Flatpak) installed successfully."
echo "Launch it using: flatpak run com.valvesoftware.Steam"
