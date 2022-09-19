#!/usr/bin/env sh

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
