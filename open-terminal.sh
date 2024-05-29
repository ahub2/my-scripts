#!/bin/sh

open_term() {
    if [ "$2" ]; then
        foot -e  distrobox enter "$1" --additional-flags "$2"
    else
        foot -e  distrobox enter "$1" 
    fi
}

if [ "$1" ]; then
    open_term "$1" "$2"
else
    SEL="$(distrobox list | awk '{if (NR>1) {print $3}}' | rofi -dmenu -p "Select Distrobox ")" 
    if [ "$SEL" ]; then 
        echo "selected $SEL"
        #distrobox enter "$SEL"
        open_term "$SEL" "--env TERM=xterm-256color"
    else
        foot
    fi

fi
