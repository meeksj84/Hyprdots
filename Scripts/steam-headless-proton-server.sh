#!/bin/bash

set -e

# Install dependencies
sudo pacman -S --noconfirm steamcmd wget tar unzip

# Create user for running server (optional but safer)
SERVER_USER=steamserver
if ! id "$SERVER_USER" &>/dev/null; then
  sudo useradd -m -s /bin/bash "$SERVER_USER"
fi

# Setup steamcmd directory
STEAMCMD_DIR="/home/$SERVER_USER/steamcmd"
mkdir -p "$STEAMCMD_DIR"
cd "$STEAMCMD_DIR"

# Download and extract steamcmd
if [ ! -f steamcmd.sh ]; then
  echo "Downloading SteamCMD..."
  wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
  tar -xvzf steamcmd_linux.tar.gz
fi

# Optional: Create server install script
cat > "$STEAMCMD_DIR/install_csgo_ds.txt" <<EOF
@ShutdownOnFailedCommand 1
@NoPromptForPassword 1
login anonymous
force_install_dir ./csgo-ds
app_update 740 validate
quit
EOF

# Run steamcmd to install CSGO dedicated server as an example
echo "Installing CSGO Dedicated Server..."
sudo -u "$SERVER_USER" ./steamcmd.sh +runscript install_csgo_ds.txt

echo ""
echo "✅ CSGO Dedicated Server installed at $STEAMCMD_DIR/csgo-ds"
echo "To launch, switch to $SERVER_USER and run the server executable."

