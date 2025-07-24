#!/bin/bash
# fix-missing-firmware.sh
# Script to detect and fix missing firmware warnings during pacman -Syu

LOGFILE="/var/log/fix-missing-firmware.log"
MISSING_FW_LOG="/tmp/missing-fw.log"

echo "=== Fix Missing Firmware Script ===" | tee -a "$LOGFILE"
echo "Date: $(date)" | tee -a "$LOGFILE"
echo "Checking for missing firmware..." | tee -a "$LOGFILE"

# Step 1: Run dmesg to detect missing firmware
dmesg | grep -i "firmware" | grep -i "failed" | tee "$MISSING_FW_LOG"

if [[ -s "$MISSING_FW_LOG" ]]; then
    echo "Missing firmware detected:" | tee -a "$LOGFILE"
    cat "$MISSING_FW_LOG" | tee -a "$LOGFILE"

    # Step 2: Ensure linux-firmware is installed and up to date
    echo "Installing or updating linux-firmware..." | tee -a "$LOGFILE"
    sudo pacman -Sy --noconfirm linux-firmware | tee -a "$LOGFILE"

    # Optional: Rebuild initramfs (if firmware is needed early in boot)
    echo "Rebuilding initramfs..." | tee -a "$LOGFILE"
    sudo mkinitcpio -P | tee -a "$LOGFILE"

    echo "Firmware fix attempt complete. Reboot may be necessary." | tee -a "$LOGFILE"
else
    echo "No missing firmware messages found." | tee -a "$LOGFILE"
fi
