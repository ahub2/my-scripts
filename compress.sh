#!/bin/sh

help () {
    echo "script to compress/extract files using 7z and unrar"
    echo "    -c [ files/directories ]  =>  compress input directories or files, if only one file is passed, the filename will be used as the archive name. If passing multiple files, surround all filenames with quotes, i.e. compress.sh -c \"file1.txt file2.txt dir1\" "
    echo "    -e [ file ]               =>  extract input file to the current directory"
    echo "    -l [ file ]               =>  print contents of file to stdout"
    echo "    -h                        =>  show this help menu"
    exit 0
}

compress() {
    FILES="$@"
    echo "compressing files: $FILES"

    NUMFILES="$(echo $FILES | wc -w)"
    BASENAME="$(basename $FILES)"

    # if only one file is passed, use filename as archive name, otherwise prompt user for input 
    if [ $NUMFILES = "1" ]; then
        fn="$BASENAME"
    else
        echo "input filename for archive"
        read fn
    fi

    fn=$fn.7z
    echo "creating archive $fn"

    if ! [ -e $fn ]; then
        for F in $FILES 
        do 
            echo "adding file $F to archive"
            7z a $fn $F

        done

    else
        echo "ERROR file: $fn exists, exiting."
        exit 1
    fi

    exit 0
}

extract() {
    FILE="$@"
    echo "extracting: [$FILE]"

    case "$FILE" in 
        *.rar) 
            unrar x "$FILE"
            exit 0
            ;;
        *) 
            7z x "$FILE"
            exit 0
            ;;
    esac
    exit 0
}

list() {
    FILE="$1"

    case "$FILE" in 
        *.rar) 
            unrar l "$FILE"
            exit 0
            ;;
        *) 
            7z l "$FILE"
            exit 0
            ;;
    esac
    exit 0
}

#input argument handling code copied from: https://stackoverflow.com/a/14203146
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file=""
input_files=""
verbose=0

[ $# = "0" ] && help 

while getopts "h?c:e:l:" opt; do
    case "$opt" in
        h|\?)
            help
            ;;
        c) 
            compress $OPTARG
            exit 0
            ;;
        e) 
            extract $OPTARG
            exit 0
            ;;
        l)
           list $OPTARG
           exit 0
           ;;
    esac
done
