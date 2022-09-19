#!/bin/sh
#run this to start gammastep
#got this from https://rumpelsepp.org/blog/geolocation-for-gammastep/
#modified to be a posix shell script, and to save location data to a file 
#so gammastep still works if internet is out.

FN="$HOME/.cache/gs_geoclue.json"

curl -Ls https://ipapi.co/json > "$FN"
gammastep -l "$( cat "$FN" | jq ".latitude" )":"$( cat "$FN" | jq ".longitude" )" -m wayland
