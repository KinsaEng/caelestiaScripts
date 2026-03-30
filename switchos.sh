#!/bin/bash

WINDOWS_ID=$(efibootmgr | awk '/Windows Boot Manager/ {print substr($1,5,4)}')

echo "ID: $WINDOWS_ID"
###################################################
## DONT FORGET TO CHANGE WITH YOUR SUDO PASSWORD ##
###################################################
echo $YOUR_SUDO_PASS | sudo -S efibootmgr -n $WINDOWS_ID
