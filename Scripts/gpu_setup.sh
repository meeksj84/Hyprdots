#!/bin/bash

LOGFILE="/var/log/gpu_setup.log"
exec > >(tee -a "$LOGFILE") 2>&1

set -e

echo "===== GPU Setup Script Started on $(date) ====="
echo "[+] Scanning your system for GPUs..."

lspci | grep -E "VGA|3D"

INTEL=$(lspci | grep -i 'vga' | grep -i 'intel')
AMD=$(lspci | grep -i 'vga' | grep -i 'amd')
NVIDIA=$(lspci | grep -i '3d\|vga' | grep -i 'nvidia')

install_yay() {
  echo "[+] Installing yay (AUR helper)..."
  sudo pacman -S --needed git base-devel
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
}

install_packages() {
  echo "[+] Installing official packages: $*"
  sudo pacman -S --needed --noconfirm $@
}

install_aur_package() {
  if ! command -v yay &>/dev/null; then
    read -p "[?] 'yay' is not installed. Install it now? (y/N): " choice
    [[ "$choice" =~ ^[Yy]$ ]] && install_yay || exit 1
  fi
  yay -S --noconfirm "$@"
}

check_wayland() {
  echo "[+] Checking session type..."
  SESSION_TYPE=$(loginctl show-session "$(loginctl | grep $(whoami) | awk '{print $1}')" -p Type | cut -d= -f2)
  if [[ "$SESSION_TYPE" == "wayland" ]]; then
    echo "[!] WARNING: You are using Wayland. 'optimus-manager' only works with X11."
    echo "[!] Please switch to an X11 session for hybrid graphics switching to work."
  else
    echo "[+] X11 session detected. Proceeding."
  fi
}

echo "[+] Installing base GPU packages..."
install_packages mesa mesa-demos vulkan-icd-loader lib32-vulkan-icd-loader

# Detect and install drivers
if [[ -n "$INTEL" ]]; then
  echo "[+] Intel GPU detected."
  install_packages xf86-video-intel vulkan-intel lib32-vulkan-intel
fi

if [[ -n "$AMD" ]]; then
  echo "[+] AMD GPU detected."
  install_packages xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon
fi

if [[ -n "$NVIDIA" ]]; then
  echo "[+] NVIDIA GPU detected."
  install_packages nvidia nvidia-utils lib32-nvidia-utils nvidia-settings
fi

# Handle hybrid setups
if [[ -n "$INTEL" && -n "$NVIDIA" ]]; then
  echo "[+] Hybrid GPU setup detected: Intel + NVIDIA"
  check_wayland
  install_aur_package optimus-manager optimus-manager-qt
  sudo systemctl enable optimus-manager.service
  echo "[*] You can switch GPU modes using: optimus-manager --switch nvidia/intel"
elif [[ -n "$AMD" && -n "$NVIDIA" ]]; then
  echo "[+] Hybrid GPU setup detected: AMD + NVIDIA"
  install_packages switcheroo-control
  echo "[*] Use DRI_PRIME=1 to run apps with discrete GPU. Example:"
  echo "    DRI_PRIME=1 glxinfo | grep 'OpenGL renderer'"
fi

echo "[✓] GPU driver and switching software installation complete."
echo "    Log saved to $LOGFILE"

read -p "[?] Do you want to reboot now to apply changes? (y/N): " reboot_choice
if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
  echo "[+] Rebooting..."
  reboot
else
  echo "[*] Please reboot manually to complete GPU switching setup."
fi

