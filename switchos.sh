#!/bin/bash

echo $YOUR_SUDO_PASS | sudo -S efibootmgr -n 0001
reboot
