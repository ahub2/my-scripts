#!/bin/sh
sudo pacman -S opendoas

echo "permit persist $USER as root" > ~/.cache/doas.conf
echo "permit nopass :wheel as root cmd /sbin/poweroff" >> ~/.cache/doas.conf
echo "permit nopass :wheel as root cmd /sbin/reboot" >> ~/.cache/doas.conf
sudo cp ~/.cache/doas.conf /etc/doas.conf

yay -S opendoas-sudo
