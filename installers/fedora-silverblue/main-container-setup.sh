#!/bin/sh

sudo dnf -y install dnf5 dnf5-plugins

sudo dnf5 -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

sudo dnf5 copr enable pennbauman/ports
sudo dnf copr enable derisis13/ani-cli

#media tools 
sudo dnf5 -y install mpv ncmpcpp yt-dlp yt-dlp-zsh-completion chafa imv
sudo dnf5 -y install  ani-cli

#cli tools 
sudo dnf5 -y  install lf neovim htop nvtop 

#archive handling
sudo dnf5 -y install p7zip p7zip-plugins unrar

sudo dnf5 -y install mpd --allowerasing

#background stuff needed for scripts, etc.
# xpdf gives the pdftotext command for pdf previews
sudo dnf5 -y install ImageMagick bat ffmpegthumbnailer file xpdf trash-cli srm

#gui programs
sudo dnf5 -y install zathura zathura-cb zathura-djvu zathura-pdf-mupdf

#misc
sudo dnf5 -y install foot-terminfo iputils

#development stuff
sudo dnf5 -y install git python3-pip g++
sudo dnf5 -y group install development-tools 
sudo dnf5 -y install man-db

#install dbus-daemon to get flatpaks to work inside distrobox
sudo dnf5 -y install dbus-daemon
sudo mkdir /run/dbus
# run: "sudo dbus-daemon --system" before running a flatpak
#


#misc needed for random programs
sudo dnf5 -y install libatomic gstreamer1-vaapi GConf2 zenity


#install usoc mpv config
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh)"

# install fastanime
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install "fastanime[mpv]"

