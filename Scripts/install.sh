#!/bin/bash
set -e  # Exit on error

echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install base-devel and git
echo "Installing git and base-devel..."
sudo pacman -S --needed --noconfirm git base-devel

# Install yay if not present
if ! command -v yay &> /dev/null; then
  echo "Installing yay..."
  WORKDIR=$(mktemp -d)
  cd "$WORKDIR"
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ~
  rm -rf "$WORKDIR"
  echo "yay installation complete!"
else
  echo "yay already installed."
fi

# Clone Hyprdots
echo "Cloning Hyprdots..."
git clone https://github.com/meeksj84/Hyprdots.git || echo "Hyprdots repo already cloned."

# Install official repo packages
install_official_packages() {
  echo "Installing official packages..."
  sudo pacman -S --noconfirm kate steam fastfetch brightnessctl meld timeshift
}

# Install AUR packages
install_aur_packages() {
  echo "Installing AUR packages..."
  yay -S --noconfirm bluetuith vivaldi optimus-manager
}

# Run installations
install_official_packages
install_aur_packages

echo "Setup complete!"
