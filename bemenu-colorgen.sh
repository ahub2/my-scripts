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


COLOR00="$(sed '1!d' "$FILE")"
COLOR01="$(sed '2!d' "$FILE")"
COLOR02="$(sed '3!d' "$FILE")"
COLOR03="$(sed '4!d' "$FILE")"
COLOR04="$(sed '5!d' "$FILE")"
COLOR05="$(sed '6!d' "$FILE")"
COLOR06="$(sed '7!d' "$FILE")"
COLOR07="$(sed '8!d' "$FILE")"
COLOR08="$(sed '9!d' "$FILE")"
COLOR09="$(sed '10!d' "$FILE")"
COLOR0A="$(sed '11!d' "$FILE")"
COLOR0B="$(sed '12!d' "$FILE")"
COLOR0C="$(sed '13!d' "$FILE")"
COLOR0D="$(sed '14!d' "$FILE")"
COLOR0E="$(sed '15!d' "$FILE")"
COLOR0F="$(sed '16!d' "$FILE")"


echo "bemenu colors updated."

echo "#!/bin/sh" > "$BEMENUOPTS_FILE" 
echo "#generated from: $1" >> "$BEMENUOPTS_FILE"
#echo "export BEMENU_OPTS=\"-H $HEIGHT --tb $COLOR03 --tf $COLOR06 --fb $COLOR00 --ff $COLOR06 --nb $COLOR00 --nf $COLOR04 --hb $COLOR0A --hf $COLOR0A --sb $COLOR02 --sf $COLOR0A --scb $COLOR00 --scf $COLOR0E \"" >> "$BEMENUOPTS_FILE"
echo "export BEMENU_OPTS=\"-H $HEIGHT --tb $COLOR00 --tf $COLOR0A --fb $COLOR00 --ff $COLOR09 --nb $COLOR02 --nf $COLOR0A --hb $COLOR06 --hf $COLOR06 --sb $COLOR01 --sf $COLOR06  \"" >> "$BEMENUOPTS_FILE"
