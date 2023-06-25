#!/bin/sh

open_term() {
    foot -e  distrobox enter "$1" --additional-flags "--env TERM=xterm-256color"
}

if [ "$1" ]; then
    open_term "$1"
else
    SEL="$(distrobox list | awk '{if (NR>1) {print $3}}' | rofi -dmenu -p "Select Distrobox ")" 
    if [ "$SEL" ]; then 
        echo "selected $SEL"
        #distrobox enter "$SEL"
        open_term "$SEL"
    else
        foot
    fi

fi
