#!/bin/sh

mkname() {
    FILES="$( echo "$@" | head -1 - )"

    NAME="$(echo "$FILES" | awk '{print $1}' | xargs -0 basename | cut -f 1 -d '.')" 

    #C=0 #create counter variable in case of infinite loop
    #while : 
    #do
    #    case "$NAME" in
    #        *.*) NAME="$(echo "$NAME" | cut -f 2 -d '.')" ;; #trim file extensions
    #        #.*) NAME="$(echo "$NAME" | sed 's/^\.//g')" ;; #trim leading periods
    #        /*) NAME="$(echo "$NAME" | sed 's/^\///g')" ;; #trim leading slashes
    #        *)     break;;                                 #break if all above conditions are gone
    #    esac
    #
    #    C=$((C + 1))
    #    [ $C -gt 10 ] && break #if counter limit reached break loop
    #done

    echo "$NAME" 
}

compress() {
    set -f
    echo "@ = $@"
    FILES="$(echo "$@" | xargs -0)"
    echo "FILES = $FILES"

    DIRNAME="$(basename "$FILES")"
    echo "DIRNAME = $DIRNAME"

    if ! [ -d "$DIRNAME" ]; then
        DIRNAME="$(mkname "$@")"

        echo "making directory $DIRNAME"
        mkdir "$DIRNAME"
        for f in $FILES
        do
            cp -r "$f" "$DIRNAME"
        done
        DELFLAG="TRUE"      #set delete flag if we created a temp directory
    fi

    echo "enter compression type [tar.gz, zip, 7z(default)]: "
    read TYPE

    case "$TYPE" in
        tar.gz) tar czf "$DIRNAME".tar.gz "$DIRNAME";;
        zip) zip -r "$DIRNAME".zip "$DIRNAME";;
        *) 7z a "$DIRNAME".7z "$DIRNAME";;
    esac

     [ "$DELFLAG" ] && rm -rf "$DIRNAME"
}

extract() {
    set -f
    FILE="$(echo "$1" | xargs)" #use xargs to trim whitespace
    DIR="$(basename "$FILE" | cut -f 1 -d '.')"
    mkdir "$DIR" 
    case $FILE in
        *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf "$FILE" --directory="$DIR";;
        *.tar.gz|*.tgz) tar xzvf "$FILE" --directory="$DIR";;
        *.tar.xz|*.txz) tar xJvf "$FILE" --directory="$DIR";;
        *.zip) unzip "$FILE" -d "$DIR";;
        *.rar) unrar x "$FILE" "$DIR";;
        *.7z | *.crx) 7z x "$FILE" -o"$DIR";;
    esac
}

help () {
    echo "script to compress/extract files using tar/zip/rar"
    echo "    -c [ files/directories ]  =>  compress input files/directories"
    echo "    -e [ file ]               => extract input file to a subdirectory of the files name"
}

#get all input except first argument, if first argument has a '-' and save in ARGS
#ARGS="$( echo "$@" | sed 's/^-.* //g' )" 
ARGS="$2"

echo "ARGS = $ARGS"

if [ "$1" = "-c" ]; then
    compress "$ARGS"
elif [ "$1" = "-e" ]; then
    extract "$ARGS"
else
    help
fi
