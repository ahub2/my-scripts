#!/bin/sh

yay -S system76-firmware-daemon
sudo systemctl enable --now system76-firmware-daemon
sudo gpasswd -a $USER adm

yay -S firmware-manager #unable to install this

#yay -S system76-driver  #system76 recommends
yay -S system76-driver-git

sudo systemctl enable --now system76

yay -S system76-power

sudo systemctl enable com.system76.PowerDaemon.service
sudo systemctl start com.system76.PowerDaemon.service

yay -S system76-firmware

sudo pacman -S linux-headers

yay -S system76-dkms

yay -S system76-io-dkms

yay -S system76-oled


#later uninstalled system76-driver and installed system76-driver-git
