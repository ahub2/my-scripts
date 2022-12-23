#!/bin/sh

    #enable multilib
    if  [ -z "$(grep "^\[multilib" /etc/pacman.conf)" ]; then
        sudo sh -c "echo "[multilib]" >> /etc/pacman.conf"
        sudo sh -c "echo "Include\ =\ /etc/pacman.d/mirrorlist" >> /etc/pacman.conf"
        sudo sh -c "echo "" >> /etc/pacman.conf"
    fi

    for arg in "$@"
    do
        if [ "$arg" = "--nvidia" ]; then 
            NVIDIA_GPU="TRUE"
        elif [ "$arg" = "--amd" ]; then
            AMD_GPU="TRUE"
        elif [ "$arg" = "--intel" ]; then
            INTEL_GPU="TRUE"
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


    [ -z "$(grep "^\[lib32" /etc/pacman.conf)" ] && [ -z "$NVIDIA_GPU" ] && [ -z "$AMD_GPU" ] && [ -z "$INTEL_GPU" ] && exit

    [ "$NVIDIA_GPU" = "TRUE" ] && sudo pacman -S nvidia-utils lib32-nvidia-utils
    [ "$AMD_GPU" = "TRUE" ] && sudo pacman -S vulkan-radeon lib32-vulkan-radeon
    [ "$INTEL_GPU" = "TRUE" ] && sudo pacman -S vulkan-intel lib32-vulkan-intel

    sudo pacman -S vulkan-mesa-layers lib32-vulkan-mesa-layers

    sudo pacman -S  wine winetricks
    sudo pacman -S giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader lib32-pipewire lib32-pipewire-v4l2 lib32-pipewire-jack cups samba dosbox

    sudo pacman -S gamemode lib32-gamemode
    sudo pacman -S lutris steam

    yay -S protonup-git
