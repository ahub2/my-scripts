#!/bin/sh
#Script wrapper for using grim for screenshots in sway
#commands taken from grim's github README, commands saved below for reference
#requires that sway, grim, jq, and imagemagick are installed

#for all functions:
# $1 -> filename for output, will be set to - if -clip flag is set 
# $2 -> program to pipe grim output to, defaults to cat, is set to wl-copy if -clip is set
# $3 -> seconds to wait before taking screenshot

ss_all() {
    sleep "$3"
    grim "$1" | "$2" 
}

ss_mon() {
    sleep "$3"
    grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" "$1" | "$2"
}

ss_win() {
    sleep "$3"
    grim -g "$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')" "$1" | "$2" 
}

ss_sel() {
    grim -g "$(slurp && sleep "$3")" "$1" | "$2" 
}

ss_color_pick() {
    grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:- | "$2" 
}

help() {
    echo "ss.sh [OPTIONS]"
    echo "    -a             ->   take screenshot of entire display"
    echo "    -m             ->   take screenshot of current monitor"
    echo "    -w             ->   take screenshot of currently active window"
    echo "    -s             ->   take screenshot of selection"
    echo "    -o FILENAME    ->   override filename output with given string FILENAME"
    echo "    --color-picker ->   get the current color value of a selected pixel, prints data to stdout"
    echo "    --clip         ->   copy image to clipboard instead of writing to file"
    echo "    --secs SECS    ->   wait SECS seconds before taking screenshot" 
    echo "    --help         ->   print this help message"
    echo ""
}

CMD="help"

FN=$(date +'%s_grim.png')

SECS="0"

FN_FLAG=""
SL_FLAG=""

PIPE_CMD="cat"

for ARG in "$@"
do
    [ "$ARG" = "-a" ]           && CMD="ss_all" 
    [ "$ARG" = "-m" ]           && CMD="ss_mon" 
    [ "$ARG" = "-w" ]           && CMD="ss_win" 
    [ "$ARG" = "-s" ]           && CMD="ss_sel" 
    [ "$ARG" = "--color-picker" ] && CMD="ss_color_pick" 
    [ "$ARG" = "--clip" ]          && FN="-" && PIPE_CMD="wl-copy"
    [ "$ARG" = "--help" ]         && CMD="help" 

    [ "$FN_FLAG" = "1" ] && FN_FLAG="" && FN="$ARG"      #turn off FN_FLAG and set FN to argument after -o
    [ "$ARG" = "-o" ]    && FN_FLAG="1"                  #flag next argument to be file name 

    [ "$SL_FLAG" = "1" ] && SL_FLAG="" && SECS="$ARG"    #turn off SL_FLAG and set SECS to argument after -secs 
    [ "$ARG" = "-secs" ] && SL_FLAG="1"                  #flag next argument to be SECS 

done 

$CMD "$FN" "$PIPE_CMD" "$SECS"
