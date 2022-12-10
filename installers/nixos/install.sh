#!/bin/sh

mkdir ~/docs/
mkdir ~/dl/
mkdir ~/media/
mkdir -p ~/.local/share/gnupg/
mkdir -p ~/.config/mpd/playlists
mkdir -p ~/.local/share/desktop

#setup .zprofile and zsh history file
cd ~ || return
ln -s ~/.profile ~/.zprofile
mkdir -p ~/.cache/zsh
touch ~/.cache/zsh/history


sh ~/.local/scripts/install.sh add-repos ~/.local/installers/nixos/repos.list


#link rofi themes directory so that theming works
mkdir -p "$HOME"/.local/share/rofi/
ln -s "$HOME"/.local/src/base16-rofi/themes/ "$HOME"/.local/share/rofi/themes



#set limits for esync
#sudo sh -c "echo '$USER hard nofile 524288' >> /etc/security/limits.conf"
#set limits for monero
#sudo sh -c "echo '$USER hard memlock 2048' >> /etc/security/limits.conf"
#sudo sh -c "echo '$USER hard memlock 2048' >> /etc/security/limits.conf"

#fix issue with arduino ide and tiling wms
#sudo sh -c 'echo "export _JAVA_AWT_WM_NONREPARENTING=1" >> /etc/profile.d/jre.sh'

#download collapse OS
mkdir -p "$HOME"/.local/src/
cd "$HOME"/.local/src/
wget http://collapseos.org/files/collapseos-latest.tar.gz
cd -

#set wallpaper
ln -s ~/media/img/wallpapers/alena-aenami-eclipse-1k.jpg ~/.config/wall 

#link Xresources for xwayland
ln -s ~/.config/Xresources ~/.Xdefaults
