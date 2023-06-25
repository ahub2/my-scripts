#!/bin/sh

sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

sudo dnf -y copr enable pennbauman/ports

sudo dnf -y  install lf mpv ncmpcpp yt-dlp yt-dlp-zsh-completion chafa imv neovim p7zip p7zip-plugins unrar-free
sudo dnf -y install htop radeontop

sudo dnf -y install mpd --allowerasing

#background stuff needed for scripts, etc.
sudo dnf -y install ImageMagick bat ffmpegthumbnailer

#gui programs
sudo dnf -y install zathura zathura-cb zathura-djvu zathura-pdf-mupdf

#misc
sudo dnf -y install foot-terminfo iputils

#development stuff
sudo dnf -y install git python3-pip g++
sudo dnf -y groupinstall "Development Tools" "Development Libraries"
sudo dnf -y install man-db

#install dbus-daemon to get flatpaks to work inside distrobox
sudo dnf -y install dbus-daemon
sudo mkdir /run/dbus
# run: "sudo dbus-daemon --system" before running a flatpak
