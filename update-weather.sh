#!/usr/bin/env sh

[ "$1" = "-i" ] && sleep 10

UPDATE="$(curl --connect-timeout 30 "wttr.in/"$(cat ~/.cache/gs_geoclue.txt | sed 's/ /,/g')"?format=1")" # > ~/.cache/wttr

echo "$UPDATE" | wc -m

if [ $(echo "$UPDATE" | wc -m) -le 30 ]; then
	echo "$UPDATE" > ~/.cache/wttr
    date >> ~/.cache/wttr_update

else
	echo "❗" > ~/.cache/wttr 

fi
