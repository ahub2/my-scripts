#!/usr/bin/env sh

get() {
    val="$(curl --connect-timeout 30 "rate.sx/1$1" | sed 's/\(\.[0-9][0-9]\).*$/\1/g')"

    printf "%s: %s\n" "$1" "$val"
}

[ "$1" = "-i" ] && sleep 10


UPDATE="$(get 'LINK') $(get 'XMR')" 

if [ $(echo $UPDATE | wc -m) -le 30 ]; then
	echo "$UPDATE" > ~/.cache/rate
else
	echo "❗" > ~/.cache/rate
fi
