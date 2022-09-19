#!/bin/sh

if [ "$1" = "-e" ];then

    if [ "$2" ]; then
        tar -cvzf - "$2" | gpg -c > "$2".tar.gz.gpg
    fi

elif  [ "$1" = "-d" ];then


    if [ "$2" ]; then
        gpg -d "$2" | tar -xvzf -
    fi

else
    echo " $1 :  -e, encrypt $2"
    echo "       -d, decrypt $2"
    echo " $2 :  directory or file to encrypt/decrypt"

fi
