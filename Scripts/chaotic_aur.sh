#!/bin/bash
set -e

if [[ $EUID -eq 0 ]]; then
  echo "Run this as a regular user, not root."
  exit 1
fi

# 1. Import and locally sign the Chaotic‑AUR signing key
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB

# 2. Install keyring and mirrorlist packages
sudo pacman -U \
  'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
  'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# 3. Add repository to pacman.conf if not already present
if ! grep -Fxq "[chaotic-aur]" /etc/pacman.conf; then
  echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" \
    | sudo tee -a /etc/pacman.conf
fi

# 4. Update package databases
sudo pacman -Sy

echo "✅ Chaotic‑AUR setup complete."
echo "You can now install packages with: sudo pacman -S package-name"

