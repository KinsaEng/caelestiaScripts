#!/bin/bash
###################################################
## DONT FORGET TO CHANGE WITH YOUR SUDO PASSWORD ##
## ALSO MOVE THIS SCRIPT TO /usr/bin/switchos.sh ##
## cp ./switchos.sh /usr/bin/switchos.sh         ##
###################################################


WINDOWS_ID=$(efibootmgr | awk '/Windows Boot Manager/ {print substr($1,5,4)}')

echo "ID: $WINDOWS_ID"

echo $YOUR_SUDO_PASS | sudo -S efibootmgr -n $WINDOWS_ID
reboot
