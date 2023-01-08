#!/bin/sh


quit() {
    QUIT="TRUE"
    echo "SIG HANDLED"
}


trap 'quit' 2
trap 'quit' 15

[ $# -lt 1 ] && echo "input bluetooth device uuid to repeatedly attempt to connnect to as 1st arg" && exit

UUID="$1"

while [ -z "$QUIT" ] 
do
    IS_CONN="$( bluetoothctl devices Paired | grep "$UUID")"
    if [ -z "$IS_CONN" ]; then
        bluetoothctl connect "$UUID"
    fi
    sleep 5 

done

echo "SCRIPT CLOSED"
