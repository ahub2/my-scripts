#!/usr/bin/env sh
#sets a random wallpaper using feh from the ~/wallpapers directory

setwp() {
    #wal -n -s -t -e -i "$1"
    rm ~/.config/wall 
    cp "$1" "$HOME/.config/wall"
    swaymsg "output * bg ~/.config/wall fill"
    #swaybg --image "$HOME/.config/wall"
}


#TODO convert this to be usable in wayland/sway
#[ "$1" = "-r" ] && WALLP=$(find -L ~/wallpapers/ -iname "*.*" -print | shuf -n 1) && feh --bg-scale "$WALLP" && exit

#if [ -d "$1" ]; then
#    case $1 in
#        /*) sel="$(sxiv -o "$1"  | sed '$!d')" ;;
#        *) sel="$PWD/$(sxiv "$1" -o | sed '$!d')" ;;
#    esac
#    [ -f "$sel" ] && setwp "$sel"
#
#elif [ -f "$1" ]; then
#    #setwp "$PWD/$1"
#    setwp "$1"
#fi

if [ -f "$1" ]; then
    setwp "$1"
fi


