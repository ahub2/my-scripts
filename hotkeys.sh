#!/usr/bin/env sh
#add to autostart script to startup swhkd automatically/restart when login/logout

run () {
    killall swhks

    swhks & pkexec swhkd
}

close () {
    killall swhks
    sudo killall swhkd
}

if [ "$1" = "-k" ]; then
    close
else
    run
fi
