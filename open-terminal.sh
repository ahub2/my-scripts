#!/bin/sh
SEL="$(distrobox list | awk '{if (NR>1) {print $3}}' | rofi -dmenu -p "Select Distrobox ")" 

if [ "$SEL" ]; then 
    echo "selected $SEL"
    #distrobox enter "$SEL"
    foot -e  distrobox enter $SEL --additional-flags "--env TERM=xterm-256color"
else
    foot
fi
