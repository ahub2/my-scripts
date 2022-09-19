#!/usr/bin/env sh

[ "$1" = "-i" ] && sleep 10

UPDATE="$(curl --connect-timeout 30 "wttr.in/?format=1")" # > ~/.cache/wttr

echo $UPDATE | wc -m

if [ $(echo $UPDATE | wc -m) -le 30 ]; then
	echo "$UPDATE" > ~/.cache/wttr

else
	echo "❗" > ~/.cache/wttr 

fi
