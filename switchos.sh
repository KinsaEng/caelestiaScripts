#!/bin/bash
#####################################################
# One-time boot switcher to Windows via UEFI        #
#                                                   #
# Finds Windows Boot Manager automatically          #
# sets it as next boot entry, then reboots.         #
#                                                   #
# WARNING: Avoid storing sudo passwords in scripts  #
# Consider using pkexec or a polkit agent instead.  #
# NOTE: PASSWORD NEEDS TO BE SET TO WORK PROPERLY!!!#
#####################################################

INSTALL_PATH="/usr/bin/switchos.sh"
PASSWORD="YOUR_PASSWORD" # not recommended but couldn't find another convenient way for caelestia 😥

# Auto-install if not present
if [[ ! -f "$INSTALL_PATH" ]]; then
    echo "Installing script to $INSTALL_PATH ..."

    echo "$PASSWORD" | sudo -S -p "" cp "$0" "$INSTALL_PATH" || {
        echo "Error: failed to copy script."
        exit 1
    }

    echo "$PASSWORD" | sudo -S -p "" chmod +x "$INSTALL_PATH" || {
        echo "Error: failed to set permissions."
        exit 1
    }

    echo "Installed successfully."
fi

# Get Windows Boot ID safely
WINDOWS_ID=$(efibootmgr | awk '/Windows Boot Manager/ {print substr($1,5,4); exit}')

if [[ -z "$WINDOWS_ID" ]]; then
    echo "Error: Windows Boot Manager not found."
    exit 1
fi

echo "Windows Boot ID: $WINDOWS_ID"

# Set next boot to Windows
echo "$PASSWORD" | sudo -S -p "" efibootmgr -n "$WINDOWS_ID" || {
    echo "Error: failed to set next boot."
    exit 1
}

# Reboot into Windows
echo "$PASSWORD" | sudo -S -p "" reboot
