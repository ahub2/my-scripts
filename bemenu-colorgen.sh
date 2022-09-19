#!/bin/sh

BEMENUOPTS_FILE="$HOME/.config/bemenu/bemenu_opts.sh"

HEIGHT="22" #height in pixels to make the bemenu prompt

help () {
       echo "    usage: sh bemenu-colorgen.sh FILE"
       echo "       where FILE contains hex values of a base16 color scheme in this format:"
       echo "             NOTE: the file must contain 16 color values"
       echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
       echo " #282936"
       echo " #3a3c4e"
       echo " #F7CA88"
       echo " #626483"
       echo " #62d6e8"
       echo " #e9e9f4"
       echo " #f1f2f8"
       echo " #f7f7fb"
       echo " #ea51b2"
       echo " #b45bcf"
       echo " #00f769"
       echo " #ebff87"
       echo " #a1efe4"
       echo " #62d6e8"
       echo " #b45bcf"
       echo " #00f769"
       echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}


 FILE="$1"

! [ -f "$FILE" ] && help && exit
[  "$( wc -l "$FILE" | cut -d ' ' -f 1 )" != "16" ] && help && exit


NB=""
NF=""
HB=""
HF=""
SB=""
SF=""
TB=""
TF=""
FB=""
FF="#ffffff"

IFS='
'

COUNT=0
for LINE in $(cat "$FILE") 
do
    case $COUNT in
        0) NB="$LINE" && HB="$LINE" && TB="$LINE" && FB="$LINE";;
        1) SB="$LINE";;
        6) HF="$LINE" && SF="$LINE";;
        10) NF="$LINE" && TF="$LINE";;
    esac

    COUNT=$((COUNT + 1))
done

echo "bemenu colors updated."

echo "#!/bin/sh" > "$BEMENUOPTS_FILE" 
echo "#generated from: $1" >> "$BEMENUOPTS_FILE"
echo "export BEMENU_OPTS=\"-H $HEIGHT --nb $NB --nf $NF --hb $HB  --hf $HF --sb $SB  --sf $SF --tb $TB --tf $TF --fb $FB --ff $FF\"" >> "$BEMENUOPTS_FILE"
