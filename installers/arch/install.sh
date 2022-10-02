#!/bin/sh
systemd_setup() {
    echo "setting up systemd services..."

    #su -c "timedatectl set-ntp true"

    #system services
    #su -c "systemctl enable connman.service"
    #sudo systemctl enable ufw.service
    #sudo systemctl enable cronie.service
    #sudo systemctl enable systemd-timesyncd.service
    #sudo systemctl enable nix-daemon.service

    #user services
    systemctl --user enable mako.service
    systemctl --user enable mpd.service
    systemctl --user enable pipewire.service
    systemctl --user enable pipewire-pulse.service
    systemctl --user enable wireplumber.service

    echo "done setting up systemd services."
}

wireless() {
    echo "Installing wireless programs..."
    sudo pacman -S tlp iwd bluez bluez-utils

    sudo systemctl enable tlp.service
    sudo systemctl enable bluetooth.service

    sudo systemctl enable connman.service
    sudo systemctl enable iwd.service

    echo "Done installing wireless programs."
}

configuration() {
    echo "Starting installation configuration..."
#setup home directories
    mkdir ~/docs/
    mkdir ~/dl/
    mkdir ~/media/
    mkdir -p ~/.config/mpd/playlists
    mkdir -p ~/.local/share/gnupg/
    mkdir -p ~/.local/share/desktop
    mkdir -p ~/.local/share/wineprefixes/default
    mkdir -p ~/.local/share/templates
    mkdir -p ~/.local/share/public
    mkdir -p ~/media/audio
    mkdir -p ~/media/img
    mkdir -p ~/media/video
    mkdir -p ~/.local/src/
    
#setup ufw
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow http
    sudo ufw allow https
    #sudo ufw allow ssh
    sudo ufw allow ntp
    sudo ufw allow 67:68/tcp
    sudo ufw allow 53

    #allow torrent client traffic
    sudo ufw allow 56881:56889/tcp

    #rules to allow steam
    sudo ufw allow 27000:27036/udp
    sudo ufw allow 27036:27037/tcp
    sudo ufw allow 4380/udp

    sudo ufw enable

#zsh setup
    chsh -s /bin/zsh "$USER"

    #setup .zprofile and zsh history file
    cd ~ || return
    ln -s ~/.profile ~/.zprofile
    mkdir -p ~/.cache/zsh
    touch ~/.cache/zsh/history

#limits.conf configuration
    #set limits for esync
    sudo sh -c "echo '$USER hard nofile 524288' >> /etc/security/limits.conf"

    #set limits for monero
    sudo sh -c "echo '$USER hard memlock 2048' >> /etc/security/limits.conf"
    sudo sh -c "echo '$USER hard memlock 2048' >> /etc/security/limits.conf"

#fixes
    sudo sh -c 'echo "export _JAVA_AWT_WM_NONREPARENTING=1" >> /etc/profile.d/jre.sh'

#theming
    sudo sh -c 'echo "FONT=Lat2-Terminus16" >> /etc/vconsole.conf'
    ln -s /usr/share/backgrounds/archlinux/lone.jpg ~/.config/wall 
    ln -s ~/.config/Xresources ~/.Xdefaults

#download collapse OS if it is not already
    if ! [ -f "$HOME/.local/src/collapseos-latest.tar.gz" ]; then
        echo "downloading collapseOS"
        cd "$HOME"/.local/src/
        wget http://collapseos.org/files/collapseos-latest.tar.gz
        cd -
    fi

    echo "Done performing installation configuration."

}

makepkg -si

#do any installation steps here
echo "installing..."

systemd_setup

configuration

clear

echo "Install wireless programs? (iwd bluez and tlp) (y/N)?"
read input
[ "$input" = "y" ] && wireless

echo "installing AUR packages..."
sh ./SCRIPTS/aur-install.sh
echo "Done installing AUR packages."
echo ""

echo "installation complete."

echo "optional extra installation scripts are located in ./SCRIPTS/ for setting up gaming, etc."


