#!/bin/sh

PROGRAM_NAME="wayland-idle-inhibitor.py"

help() {
    echo "use to toggle inhibiting idle on wayland"
    echo ""
    echo "usage: caffeine.sh [OPTIONS]"
    echo ""
    echo "    -i  -  initialize and begin inhibiting idle, which will stop the computer from sleeping." 
    echo "    -s  -  get status of program, return ON if idle is inhibited, or OFF if idle is not inhibited"
    echo "    -k  -  kill program inhibiting idle, allowing the computer to sleep" 
    echo ""
    
    exit
}

if [ "$1" = "-i" ]; then
    $PROGRAM_NAME

elif [ "$1" = "-s" ]; then
    if [ "$(pgrep -f $PROGRAM_NAME)" ]; then
        echo "ON"
    else
        echo "OFF"
    fi
elif [ "$1" = "-k" ]; then
    pkill -f "$PROGRAM_NAME" 
else
    help
fi

wait
