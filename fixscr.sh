#!/bin/sh

RES="1920x1080"
MON="VGA-1"
LAPTOP="LVDS-1"


list_mons() {
    wlr-randr | grep -v "^ " | awk '{print $1}'
}

get_mon() {
    echo "$(list_mons)" | bemenu -p "Select monitor: "
}

#$1 -> monitor to get resolutions of
get_res() {
    if [ -z "$1" ]; then 
        echo "$RES"
    else 
        echo "$(wlr-randr | sed '1,/VGA-1/d' | sed '1,/[0-9]/d' | awk '{print $1}')" | bemenu
    fi
}

laptop_only() {
    wlr-randr --output VGA-1 --off #TODO only needed because my thinkpad has an issue, remove when no longer needed 
    wlr-randr --output "$LAPTOP" --on 
}

#$1 -> monitor
#$2 -> resolution
monitor_only() {
    MON="$1"
    RES="$2"
    
    echo "$MON $RES" >> ~/.cache/log/fixscrsh.log

    [ -z "$1" ] && MON="$(get_mon)"
    [ -z "$2" ] && RES="$(get_res "$MON")" 

    wlr-randr --output "$LAPTOP" --off 
    wlr-randr --output "$MON" --on --mode "$RES" 
}

span() {
    MONS="$(list_mons)"
    for i in $MONS
    do
        wlr-randr --output "$i" --on 
    done
}

menu() {
OPTS="laptop_only
monitor_only
mirror
span
quit"

    SEL="$(echo "$OPTS" | bemenu)"

    [ "$SEL" = "laptop_only" ] && laptop_only
    [ "$SEL" = "monitor_only" ] && monitor_only
    [ "$SEL" = "span" ] && span 
}

help() {
    echo "Usage: ./fixscr.sh"
    echo "    --menu                                  => show bemenu prompts to select monitor configuration"
    echo "    --laptop-only                           => enable only laptop" 
    echo "    --monitor-only [MONITOR] [RESOLUTION]   => enable only external monitor"
    echo "    --help                                  => show this help prompt"
}

[ "$2" ] && MON="$2"
[ "$3" ] && RES="$3"

if [ "$1" = "--menu" ]; then
    menu
else
    [ "$1" = "--monitor-only" ] && monitor_only "$MON" "$RES"
    [ "$1" = "--laptop-only" ] && laptop_only 
    [ -z "$1" ] && help
fi
