#!/bin/sh
#=========================================================================
# This script is used to set the status bar for dwm, or 
# other wms that use xsetroot for a status bar. 
#
# by default this script will only run once, to run in 
# a loop give it the -l flag: ./sway-bar.sh -l
#
# Requires: pamixer
# 
# ddate -> creates a date string
# audio -> creates a string representing the state of pulseaudio
# netup -> creates a string for the current network interface and status
# weather -> reads file written by ~/scripts/update-weather.sh to set the weather 
#
# update -> calls all the above functions into swaybar to set status bar
#
# https://gitlab.com/ahub/dotfiles
#========================================================================

MAIL_DIR="$HOME/.local/share/mail"

SEP="  |  "

BATTERY_DEV="$(ls /sys/class/power_supply | grep -v AC | head -n1 )"

ddate () {
	printf " %s\n" "$(date "+%b %d, %Y ( %I:%M )")" #(%a)
}


audio () {
   #volstat="$(amixer get Master)"
   # if [  -n "$(echo "$volstat" | grep "\[off\]")" ]; then
   #     icon="🔇"
   # else
   #		icon="$(echo "$volstat" | grep -o "\[[0-9]\+%\]" | sed 's/[^0-9]*//g' | sed -n 1p -) 🔊"
   # fi

   icon="$(vol.sh -g)  🔊" 
   [ "$(pamixer --get-mute)" = "true" ] && icon="🔇"

    printf "%s\n" "$icon"
}

rss() {
    rss_cnt=$(sfeed_plain ~/.local/share/sfeed/feeds/*  | grep -c "^N" )
    #rss_cnt="$(newsboat -x print-unread | awk '{print $1}')"
    printf "%s \n" "$rss_cnt"
}

mail() {
    #MAIL_DIR="$HOME/.local/share/mail/main/INBOX/new"
    #COUNT="$(ls "$MAIL_DIR" | wc -l)"

    COUNT=0
    for MBOX in $(ls "$MAIL_DIR")
    do
        TMP_DIR="$MAIL_DIR""/$MBOX""/INBOX/new"
        COUNT=$((COUNT+$(ls "$TMP_DIR" | wc -l)))

    done
    
    icon="$COUNT 📧"

    printf "%s\n" "$icon"

}

netup() {
	icon="❗"
	for iface in $(ls -1 /sys/class/net | sed '/^lo/d')
	do
    	if [ $(cat /sys/class/net/"$iface"/operstate | grep up) ] ; then
        	if [ "$(echo "$iface" | grep w)" ]; then
            	icon=" "     
        	else
            	icon=""
        	fi
    	elif [ -z "$icon" ]; then
        	icon="❗"
    	fi
	done

	printf "%s\n" "$icon"
}

weather() {
	if ! [ -f ~/.cache/wttr ]; then
		sh ~/.local/scripts/update-weather.sh
	fi
	icon="$(cat ~/.cache/wttr)"

	printf "%s\n" "$icon"
}

cputemp() {
	icon="$(cat /sys/class/thermal/thermal_zone0/temp | sed 's/\(.\)..$/.\1°C/')"

	printf "%s\n" "$icon"
}

battery() {
    #BATT_DIR="/sys/class/power_supply/BAT0"
    BATT_DIR="/sys/class/power_supply/$BATTERY_DEV"

    if [ -d "$BATT_DIR" ]; then  
        status="$(cat "$BATT_DIR"/status)"
        charge="$(cat "$BATT_DIR"/capacity)"
    fi
	icon=""
	if [ "$status" = "Discharging" ]; then
		icon="${charge}% 🔋"	
    elif [ -z "$status" ]; then
        icon="🔌"
	else 
		icon="${charge}% 🔌"	
	fi

	printf "%s\n" "$icon"
}

crypto() {
    icon="$(cat ~/.cache/rate)"
    printf "%s\n" "$icon"
}

update() {
    echo " $SEP$(battery)$SEP$(cputemp)$SEP$(netup)$SEP$(audio)$SEP$(rss)$SEP$(weather)$SEP$(ddate) "
}


#trap 'exit' 2
#trap 'exit' 15
#trap 'exit' 9
if [ "$1" ] && [ "$1" = "-l" ]; then    
    echo "$$" > ~/.cache/statusbar_pid

    #sh ~/.local/scripts/update-crypto.sh -i >> /dev/null &
    #sh ~/.local/scripts/update-weather.sh -i >> /dev/null &

    while true
    do
        update    
        sleep 60 
    done
else 
    update
fi
