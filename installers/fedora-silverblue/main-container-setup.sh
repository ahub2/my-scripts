#!/bin/sh

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

sudo dnf copr enable pennbauman/ports

sudo dnf install lf mpv ncmpcpp yt-dlp yt-dlp-zsh-completion chafa imv neovim p7zip
sudo dnf install htop radeontop

sudo dnf install mpd --allowerasing

#background stuff needed for scripts, etc.
sudo dnf install ImageMagick bat ffmpegthumbnailer

#gui programs
sudo dnf install zathura zathura-cb zathura-djvu zathura-pdf-mupdf

#misc
sudo dnf install foot-terminfo iputils

#development stuff
sudo dnf install git python3-pip g++
sudo dnf groupinstall "Development Tools" "Development Libraries"
sudo dnf install man-db


sudo dnf install rofi-wayland

sudo dnf copr enable derisis13/ani-cli
sudo dnf install ani-cli
