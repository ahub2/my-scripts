#!/bin/sh

[ -z "$PFILE" ] && PFILE="$HOME/Documents/pass.gpg"


mkpass() {
    echo "enter password to store encrypted: "
    read input

    echo "$input" | gpg -c > "$PFILE"

    echo "password file: $PFILE created. call script without args to get the password. Run -i again on the same file to change password."
}

getpass() {
    gpg -d "$PFILE" 2>/dev/null 
}

getpass_clipboard() {
    wl-copy "$(getpass)"
    notify-send "get-pass.sh" "Password copied to clipboard. Clearing clipboard in 10 seconds"
    sleep 10
    wl-copy --clear
    notify-send "get-pass.sh" "Clipboard cleared" 
}


if [ "$1" = "-i" ]; then
    mkpass
elif [ "$1" = "-c" ]; then
    getpass_clipboard
else
    if [ -f "$PFILE" ]; then
        getpass
    else
        echo "password file: $PFILE not found. create with get-pass.sh -i"
    fi
fi
