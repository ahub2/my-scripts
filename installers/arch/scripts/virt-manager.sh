#!/bin/sh
echo "install virt-manager?(y/N)"
read -r input
if [ "$input" = "y" ] || [ "$input" = "Y" ]; then
    sudo pacman -S --noconfirm sudo pacman -S libvirt qemu virt-manager lxsession
    sudo pacman -S --noconfirm gst-plugins-good libvirt-runit

    sudo usermod -G libvirt -a "$USER"
fi

#TODO need to enable systemd services

