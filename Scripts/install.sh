#!/bin/bash

#script to install my hyprdots and configs



#INSTALLING YAY
# Exit immediately on error
set -e

# Check for root privileges
if [[ $EUID -eq 0 ]]; then
  echo "This script should NOT be run as root. Run it as a regular user."
  exit 1
fi

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install necessary packages if not present
echo "Installing git and base-devel..."
sudo pacman -S --needed --noconfirm git base-devel

# Create a temporary directory
WORKDIR=$(mktemp -d)
cd "$WORKDIR"

# Clone yay from AUR
echo "Cloning yay AUR repository..."
git clone https://aur.archlinux.org/yay.git

# Build and install yay
cd yay
makepkg -si --noconfirm

# Clean up
cd ~
rm -rf "$WORKDIR"

echo "yay installation complete!"



#MY PACKAGES
install_packages() {
  echo "[+] Installing official packages: $*"
  sudo pacman -Syu git kate fastfetch steam brightnessctl meld
}

