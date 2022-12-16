#!/bin/sh
#run this to start gammastep
#got this from https://rumpelsepp.org/blog/geolocation-for-gammastep/
#modified to be a posix shell script, and to save location data to a file 
#so gammastep still works if internet is out.

JSFN="$HOME/.cache/gs_geoclue.json"

FN="$HOME/.cache/gs_geoclue.txt"

curl -Ls https://ipapi.co/json > "$JSFN".tmp

#dont update file if error received, could also check if an error flag is present
if [ "$(cat "$JSFN".tmp | wc -l)" -gt 4 ]; then
    mv "$JSFN".tmp "$JSFN"
    LAT="$( cat "$JSFN" | jq ".latitude" )"
    LONG="$( cat "$JSFN" | jq ".longitude" )"

    echo "$LAT $LONG" > "$FN"

fi

gammastep -l "$( cat "$FN" | cut -d' ' -f1)":"$( cat "$FN" | cut -d' ' -f2)" -m wayland
