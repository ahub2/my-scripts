#!/bin/sh


sudo pacman -S podman fuse-overlayfs

yay -S distrobox


echo "setting storage driver to btrfs, if not using btrfs change this in ~/.config/containers/storage.conf"
mkdir ~/.config/containers/

{
echo "[storage]" 
echo ""
echo "driver = \"btrfs\""  
echo "" 
} > ~/.config/containers/storage.conf

