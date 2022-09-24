#!/bin/sh


. ./programs.sh

#$1 -> repo name to enable
#$2 -> mirror list file name in /etc/pacman.d/ (default: mirrorlist)
#ex: enable_repo lib32
#ex: enable_repo community mirrorlist-arch
enable_repo() {
    REPO="$1"
    MIRRORLIST="mirrorlist"
    [ "$2" ] && MIRRORLIST="$2"

    if [ $# -gt 0 ] && [ -z "$(grep "^\[$1" /etc/pacman.conf)" ]; then
        sudo sh -c "echo "[$REPO]" >> /etc/pacman.conf"
        sudo sh -c "echo "Include\ =\ /etc/pacman.d/$MIRRORLIST" >> /etc/pacman.conf"
        sudo sh -c "echo "" >> /etc/pacman.conf"
    fi
}


#TODO only needed to enable multilib for arch
enable_repos() {
    sudo pacman -Sy


    #commenting since this is done during archinstall
    #enable multilib
    #sudo sh -c "echo "[multilib]" >> /etc/pacman.conf"
    #sudo sh -c "echo "Include\ =\ /etc/pacman.d/mirrorlist" >> /etc/pacman.conf"
    #sudo sh -c "echo "" >> /etc/pacman.conf"


    #add ungoogled chroimum OBS repo
    curl -s 'https://download.opensuse.org/repositories/home:/ungoogled_chromium/Arch/x86_64/home_ungoogled_chromium_Arch.key' | sudo pacman-key -a -
    echo '
    [home_ungoogled_chromium_Arch]
    SigLevel = Required TrustAll
    Server = https://download.opensuse.org/repositories/home:/ungoogled_chromium/Arch/$arch' | sudo tee --append /etc/pacman.conf
    sudo pacman -Sy


    sudo pacman -Sy

    #install yay for aur support
    sudo pacman -S git fakeroot base-devel 

    mkdir -p ~/.local/src/
    git clone https://aur.archlinux.org/yay.git ~/.local/src/yay/ 
    cd ~/.local/src/yay || return
    makepkg -si
    cd -

}

init_setup() {
    sudo timedatectl set-ntp true

    #system services
    sudo systemctl enable connman.service
    sudo systemctl enable ufw.service
    sudo systemctl enable cronie.service
    sudo systemctl enable systemd-timesyncd.service
    #sudo systemctl enable nix-daemon.service


    #user services
    systemctl --user enable mako.service
    systemctl --user enable mpd.service
    systemctl --user enable pipewire.service
    systemctl --user enable pipewire-pulse.service
    systemctl --user enable wireplumber.service
}

wireless() {
    sudo pacman -S tlp iwd bluez bluez-utils
    sudo pacman -S tp_smapi smartmontools ethtool  #opts for tlp

    sudo systemctl enable tlp.service
    sudo systemctl enable bluetooth.service
    
    sudo systemctl disable connman.service
    sudo cp ./services/iwd.service /etc/systemd/system/iwd.service
    sudo cp ./services/connman_iwd.service /etc/systemd/system/connman_iwd.service
    sudo systemctl enable connman_iwd.service
}

harden() {
    #install required programs
    sudo pacman -S firejail apparmor

    #enable apparmor service
    sudo systemctl enable apparmor.service
    sudo systemctl start  apparmor.service

    #configure apparmor to use firejail and configure firejail to automatically run for supported programs
    sudo apparmor_parser -r /etc/apparmor.d/firejail-default
    sudo firecfg

    #add user to /etc/firejail/firejail.users if it is not already in the file
    if [ -z "$(grep "$USER" /etc/firejail/firejail.users)" ]; then
        sudo sh -c "echo '$USER' >> /etc/firejail/firejail.users"
    fi

    echo "============================================"
    echo "     Applying Hardening Configuration"
    echo "============================================"
    echo ""
    echo "append this to your kernel params:"
    echo "     lsm=landlock,lockdown,yama,integrity,apparmor,bpf"
    echo "   systemd-boot:  /boot/loader/entries/*.conf, append to end of line beginning with \"options\""
    echo "           grub:  /etc/default/grub"
    echo ""
    echo "   run this script with the --harden flag again after rebooting to ensure all settings are applied correctly."
    echo "   press enter to continue."
    read input

    #add any firejail configuration here
        #fix mpv not being able to open some files, allows mmpv to play videos in the ~/media dir
    sudo sh -c 'echo "whitelist $HOME/media" >> /etc/firejail/whitelist-player-common.local'

}


configure() {
    #setup home directories
    mkdir ~/docs/
    mkdir ~/dl/
    mkdir ~/media/
    mkdir -p ~/.local/share/gnupg/
    mkdir -p ~/.config/mpd/playlists
    mkdir -p ~/.local/share/desktop
    mkdir -p ~/.local/share/wineprefixes/default

    mkdir .local/share/public
    mkdir .local/share/templates
     mkdir media/audio
     mkdir media/video

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



    #install zsh shell
    chsh -s /bin/zsh "$USER"

    #setup .zprofile and zsh history file
    cd ~ || return
    ln -s ~/.profile ~/.zprofile
    mkdir -p ~/.cache/zsh
    touch ~/.cache/zsh/history



    #replace sudo with doas
    echo "installing doas, symlinking to sudo, and UNINSTALLING SUDO. sudo is uninstalled using doas so permissions should be setup right if you are able to uninstall. (y/N)"

    read input
    if [ "$input" = "y" ]; then
        echo "permit persist $USER as root" > ~/.cache/doas.conf
        echo "permit nopass :wheel as root cmd /sbin/poweroff" >> ~/.cache/doas.conf
        echo "permit nopass :wheel as root cmd /sbin/reboot" >> ~/.cache/doas.conf
        sudo cp ~/.cache/doas.conf /etc/doas.conf
        rm ~/.cache/doas.conf
        doas pacman -R sudo  #&& doas ln -s /bin/doas /bin/sudo                            #TODO ARCH SPECIFIC
    fi


    #set limits for esync
    sudo sh -c "echo '$USER hard nofile 524288' >> /etc/security/limits.conf"

    #set limits for monero
    sudo sh -c "echo '$USER hard memlock 2048' >> /etc/security/limits.conf"
    sudo sh -c "echo '$USER hard memlock 2048' >> /etc/security/limits.conf"

    #fix issue with arduino ide and tiling wms
    sudo sh -c 'echo "export _JAVA_AWT_WM_NONREPARENTING=1" >> /etc/profile.d/jre.sh'

    #set console terminal font
    sudo sh -c 'echo "FONT=Lat2-Terminus16" >> /etc/vconsole.conf'

    #set grub theme
    #sudo sed -i 's/#GRUB_COLOR_NORMAL/GRUB_COLOR_NORMAL/g' /etc/default/grub
    #sudo sed -i 's/#GRUB_COLOR_HIGHLIGHT/GRUB_COLOR_HIGHLIGHT/g' /etc/default/grub

    #nix configuration
        #add user to nix-users group
    #sudo adduser -a -G nix-users "$USER"
        #add nix unstable channel
    #nix-channel --add https://nixos.org/channels/nixpkgs-unstable
    #nix-channel --update

    #download collapse OS
    mkdir -p "$HOME"/.local/src/
    cd "$HOME"/.local/src/
    wget http://collapseos.org/files/collapseos-latest.tar.gz
    cd -

    #set wallpaper
    #ln -s ~/media/img/wallpapers/alena-aenami-eclipse-1k.jpg ~/.config/wall 
    ln -s /usr/share/backgrounds/archlinux/lone.jpg ~/.config/wall 

    #link Xresources for xwayland
    ln -s ~/.config/Xresources ~/.Xdefaults

    #set /tmp to tmpfs
    if [  -z "$(grep "/tmp" /etc/fstab)" ]; then 
        sudo sh -c 'echo "tmpfs   /tmp         tmpfs   rw,nodev,nosuid,size=2G          0  0" >> /etc/fstab'
    fi

}

base() {

    #enable repos (lib32, community, and universe) and install yay 
    enable_repos

    #install all packages in $PKGS
    sudo pacman --noconfirm --needed -S - < ./pkgs/base.list

    #install all packages in $AUR_PKGS
    yay --needed -S - < ./pkgs/aur.list 

    #setup local git repos defined in $GIT_REPOS to $GIT_REPOS_DIR
    sh ~/.local/scripts/install.sh add-repos ./pkgs/repos.list

    #link rofi themes directory so that theming works
    mkdir -p "$HOME"/.local/share/rofi/
    ln -s "$HOME"/.local/src/base16-rofi/themes/ "$HOME"/.local/share/rofi/themes

    init_setup

    #configure programs, directories, change shell, etc
    configure



    #install microcode for CPU
    #echo "enter CPU type to install microcode for (amd intel)"
    #read input
    #if [ "$input" = "amd" ]; then
    #    sudo pacman -S amd-ucode     
    #elif [ "$input" = "intel" ]; then
    #    sudo pacman -S intel-ucode  
    #fi

    #rebuild kernel after install for microcode
    sudo mkinitcpio -P                         #rebuild kernel
    #sudo grub-mkconfig -o /boot/grub/grub.cfg  #update grub

    echo "installation finished"

}

help() {
    echo "    artix-install.sh"
    echo "        --base                  perform basic install. Enable repos, install programs"
    echo ""
    echo "        --gaming                install steam and lutris. Use flags --amd, --nvidia, --intel to install"
    echo "                                    with corresponding graphics drivers. Otherwise you will be prompted" 
    echo ""
    echo "        --virt-manager          install virt-manager"
    echo ""
    echo "        --wireless              install/setup programs for wifi/bluetooth"
    echo ""
    echo "        --ungoogled-chromium    install ungoogled-chromium. also installs chrome-web-store and ublock origin"
    echo ""
    echo "        --harden                enable extra security settings (apparmor, firejail), THIS NEEDS TO BE RUN"
    echo "                                     AGAIN AFTER INSTALL AND REBOOT, to ensure settings are applied correctly."
    echo "                                     make sure to follow on screen instructions to set kernel params"
}

BASE=""
GAMING=""
WIRELESS=""
UNGOOGLED_CHROMIUM=""
VIRT_MANAGER=""
HARDEN=""

for arg in "$@"
do
    [ "$arg" = "--base" ] && BASE="true"
    [ "$arg" = "--gaming" ] && GAMING="true"
    [ "$arg" = "--virt-manager" ] && VIRTMGR="true"
    [ "$arg" = "--wireless" ] && WIRELESS="true"
    [ "$arg" = "--ungoogled-chromium" ] && UNGOOGLED_CHROMIUM="true"
    [ "$arg" = "--harden" ] && HARDEN="true"
    [ "$arg" = "--help" ] && help && exit 

done

[ "$#" = "0" ] && help && exit

[ "$BASE" ] && base
[ "$GAMING" ] && gaming "$@"
[ "$WIRELESS" ] && wireless
[ "$UNGOOGLED_CHROMIUM" ] && ungoogled_chromium "$@"
[ "$VIRT_MANAGER" ] && virt_manager
[ "$HARDEN" ] && harden

