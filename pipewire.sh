#!/bin/sh

#programs to run to initialize pipewire, separated by spaces
PROGS="pipewire pipewire-pulse wireplumber"

trap 'kill' 2
trap 'kill' 15

kill() {
    for PRG in $PROGS
    do
        pkill -KILL "$PRG"
        sleep 1
    done
}


for PRG in $PROGS
do

    [ -z "$(pgrep "^$PRG\$")" ] && "$PRG" &
    sleep 1
done

wait
