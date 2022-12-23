#!/bin/sh

YAY_INSTALL_DIR="$HOME/.local/src/yay"

[ -z "$AUR_PROGS_FILE" ] && AUR_PROGS_FILE="$PWD/aur-programs.list"

aurprogs="$(cat "$AUR_PROGS_FILE")"

sudo pacman -S base-devel fakeroot

mkdir -p "$YAY_INSTALL_DIR"
git clone https://aur.archlinux.org/yay.git "$YAY_INSTALL_DIR" 
cd "$YAY_INSTALL_DIR"
makepkg -si

for pkg in $aurprogs
do
    yay -S "$pkg"

done

