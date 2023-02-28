#!/bin/sh

AUR_PROGS_FILE="$1"
YAY_INSTALL_DIR="$HOME/.local/src/yay"

yay_install() {
    sudo pacman -S base-devel fakeroot

    mkdir -p "$YAY_INSTALL_DIR"
    git clone https://aur.archlinux.org/yay.git "$YAY_INSTALL_DIR" 
    cd "$YAY_INSTALL_DIR"
    makepkg -si
}

pkg_install() {
    aurprogs="$(cat "$AUR_PROGS_FILE")"
    for pkg in $aurprogs
    do
        yay -S "$pkg"
    done
}

if [ -f "$AUR_PROGS_FILE" ]; then 

    ! [ -f "/usr/bin/yay" ] && yay_install

    pkg_install


else
    echo "enter file containing package names to install separated by newlines as first input argument" && exit
fi

