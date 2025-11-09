#!/bin/bash
set -e

echo "Updating system..."
sudo pacman -Syu --noconfirm

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
if [ ! -d "$HOME/Hyprdots" ]; then
    git clone https://github.com/meeksj84/Hyprdots.git "$HOME/Hyprdots"
else
    echo "Hyprdots repo already exists. Pulling latest changes..."
    git -C "$HOME/Hyprdots" pull
fi

GIT_REPO_PATH="$HOME/Hyprdots"
CONFIG_DEST="$HOME/.config"

install_official_packages() {
    echo "Installing official packages..."
    sudo pacman -S --noconfirm kate steam fastfetch brightnessctl meld timeshift
}

install_aur_packages() {
    echo "Installing AUR packages..."
    yay -Syu --noconfirm bluetuith vivaldi optimus-manager
}

backup_and_copy() {
    local src="$1"
    local dest="$2"

    if [ -d "$dest" ]; then
        echo "==> Backing up existing config: $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    echo "==> Copying new config from $src to $dest"
    cp -r "$src" "$dest"
}

#these paths need changed to match the file locations in Hyprdots currently located in /home/morbo/Hyprdots/Configs
copy_configs() {
    echo "==> Installing custom configs..."
    backup_and_copy "$GIT_REPO_PATH/hypr" "$CONFIG_DEST/hypr"
    backup_and_copy "$GIT_REPO_PATH/waybar" "$CONFIG_DEST/waybar"
    backup_and_copy "$GIT_REPO_PATH/wofi" "$CONFIG_DEST/wofi"
    backup_and_copy "$GIT_REPO_PATH/alacritty" "$CONFIG_DEST/alacritty"
}

# Run installations
install_official_packages
install_aur_packages
copy_configs

echo "Setup complete! 🎉"

