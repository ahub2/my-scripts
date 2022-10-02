#!/bin/sh

YAY_INSTALL_DIR="$HOME/.local/src/"

aurprogs="mutt-wizard
htim
jmtpfs
tremc-git
dashbinsh
pfetch
sysrq-enabler
wlr-randr
sfeed
udiskie
waylogout-git
ani-cli-git
connman-gtk
opendoas-sudo
shell-color-scripts
lf-sixel-git
nerd-fonts-mononoki
autotiling
cli-visualizer
wob
wayland-idle-inhibitor-git
tofi
librewolf-bin"

sudo pacman -S base-devel fakeroot

mkdir -p "$YAY_INSTALL_DIR"
git clone https://aur.archlinux.org/yay.git "$YAY_INSTALL_DIR" 
cd "$YAY_INSTALL_DIR"
makepkg -si

for pkg in $aurprogs
do
    yay -S "$pkg"

done

