#!/bin/sh
##############################################################################
# This script provides functions to install/configure certain programs
# that are more complicated ( more than just pacman -S program ) to install/setup.
# 
# These programs assume that yay, lib32, and arch's community repo has been enabled.
# If you get an error during installation try running ./artix-install.sh --base 
##############################################################################

repo_check() {
   if [ -z "$(grep "^\[multilib" /etc/pacman.conf)" ] || 
      [ -z "$(grep "^\[community" /etc/pacman.conf)" ] || 
      echo "repo check"
      [ ! -f "/usr/bin/yay" ]; then
        echo "either yay, or the lib32 or community repos have not been setup correctly. Exiting"
        exit
        
   fi
}

ungoogled_chromium() {
    #repo_check
    #echo "after repo check"

    CMD=" -S "

    [ "$1" = "-R" ] && CMD=" -Rs "


    #sudo pacman -S chromium
    sudo pacman -S ungoogled-chromium

    #yay "$CMD" aur/ungoogled-chromium-binary
    yay -S aur/chromium-extension-ublock-origin

    yay -S aur/chromium-extension-web-store
    yay -S aur/chromium-widevine
}

virt_manager() {
    repo_check

    echo "install virt-manager?(y/N)"
    read -r input
    if [ "$input" = "y" ] || [ "$input" = "Y" ]; then
        sudo pacman -S --noconfirm sudo pacman -S libvirt qemu virt-manager lxsession
        sudo pacman -S --noconfirm gst-plugins-good libvirt-runit

        #TODO move this to runit_setup
        sudo usermod -G libvirt -a "$USER"
    fi

    runit_setup --virt-manager
}

gaming() {
    repo_check

    CMD=" -S --noconfirm "

    for arg in "$@"
    do
        if [ "$arg" = "--nvidia" ]; then 
            NVIDIA_GPU="TRUE"
        elif [ "$arg" = "--amd" ]; then
            AMD_GPU="TRUE"
        elif [ "$arg" = "--intel" ]; then
            INTEL_GPU="TRUE"
        elif [ "$arg" =  "-R" ]; then
            CMD=" -Rs "
        fi
    done

    if  [ -z "$NVIDIA_GPU" ] && [ -z "$AMD_GPU" ] && [ -z "$INTEL_GPU" ]; then
        echo "Enter GPU type (amd nvidia intel):"
        read input

        [ "$input" = "amd" ] && AMD_GPU="TRUE"
        [ "$input" = "nvidia" ] && NVIDIA_GPU="TRUE"
        [ "$input" = "intel" ] && INTEL_GPU="TRUE"
    fi

    echo "Installing with:"
    [ "$AMD_GPU" = "TRUE" ] && echo "AMD GPU"
    [ "$NVIDIA_GPU" = "TRUE" ] && echo "NVIDIA GPU"
    [ "$INTEL_GPU" = "TRUE" ] && echo "INTEL GPU"
    echo "press enter to continue."
    read input


    [ -z "$(grep "^\[lib32" /etc/pacman.conf)" ] && [ -z "$NVIDIA_GPU" ] && [ -z "$AMD_GPU" ] && [ -z "$INTEL_GPU" ] && help && exit

    [ "$NVIDIA_GPU" = "TRUE" ] && sudo pacman $CMD nvidia-utils lib32-nvidia-utils
    [ "$AMD_GPU" = "TRUE" ] && sudo pacman $CMD vulkan-radeon lib32-vulkan-radeon
    [ "$INTEL_GPU" = "TRUE" ] && sudo pacman $CMD vulkan-intel lib32-vulkan-intel

    sudo pacman $CMD vulkan-mesa-layers lib32-vulkan-mesa-layers

    sudo pacman $CMD  wine winetricks #wine-staging
    sudo pacman $CMD giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader lib32-pipewire lib32-pipewire-v4l2 lib32-pipewire-jack cups samba dosbox

    sudo pacman $CMD gamemode lib32-gamemode
    sudo pacman $CMD lutris steam

    yay -S protonup-git
}

