#!/usr/bin/env bash

help() {
    echo "\$1 -> file to update or compare against"
    echo "\$2 -> -u -> update file given by \$1"
}

! [ -f "$1" ] && touch "$1" 


if [ "$2" = "-u" ]; then
    echo $(date "+%y%m%d %H") >> "$1" 
else

    LAST="$( awk 'END{print $1}' < "$1" )"
    HOUR="$( awk 'END{print $2}' < "$1" )"".0"
    HOUR_NOW="$(date +%H)"".0"

    DAYS=$(( (($(date --date="$(date +%y%m%d)" +%s) - $(date --date="$LAST" +%s) ))/(60*60*24) ))
    RET=$(bc <<< "scale=2; $DAYS + (($HOUR_NOW - $HOUR)/24.0)")

    echo "$RET"
fi
