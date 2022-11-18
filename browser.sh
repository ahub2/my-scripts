#!/usr/bin/env sh

WBROWSER=librewolf


#OPTS="             Torrent )
OPTS="Web
Video
YT
Audio
Youtube-dl audio
File
RSS
Torrent"

rss() {
#sfeed
    sed -i '$d' ~/.config/sfeed/sfeedrc
    FEED_NAME="$(echo "" | bemenu -p "Feed Name: ")"
    echo "feed \"$FEED_NAME\" \"$1\"" >> ~/.config/sfeed/sfeedrc
    echo "}" >> ~/.config/sfeed/sfeedrc

#newsboat
    #echo "$1" >> ~/.config/newsboat/urls
}


ydl() {
    OPT="default
select"

    SEL="$( echo "$OPT" | bemenu)"

    LOC="$HOME/media/audio/"

    if [ "$SEL" = "select" ]; then
        if [ ! -f ~/.cache/lf/lastpath ]; then
            mkdir -p ~/.cache/lf/
            touch ~/.cache/lf/lastpath
            echo "~" > ~/.cache/lf/lastpath
        fi
        $TERMINAL -e lf -last-dir-path ~/.cache/lf/lastpath "$(cat ~/.cache/lf/lastpath)" 
        LOC="$(cat ~/.cache/lf/lastpath)"
    fi

    cd "$LOC" 
    youtube-dl "$1" -f 140
    sleep 5

}



sel() {
    SEL="$( echo "$OPTS" | bemenu)"

    [ "$SEL" = "Web" ] && $WBROWSER "$1" && exit

    [ "$SEL" = "Video" ] && mpv "$1" && exit

    [ "$SEL" = "YT" ] && mpv --ytdl-format=18 "$1" && exit

    [ "$SEL" = "Audio" ] && $TERMINAL -e mpv "$1" && exit

    [ "$SEL" = "Youtube-dl audio" ] && ydl "$1" && exit

    [ "$SEL" = "File" ] && cd "$XDG_DOWNLOAD_DIR" && curl -O -L "$1" && exit

    [ "$SEL" = "RSS" ] && rss "$1" && exit

    [ "$SEL" = "Torrent" ] && transadd "$1" && exit
    
#$WBROWSER "$1"
}

if [ -z "$1" ]; then 
    #$WBROWSER #URL="$( xclip -o | sed 's/$//g')"  && sel "$URL" && exit 
    #$WBROWSER #URL="$(wl-paste)"  && sel "$URL" && exit 
    sel "$(wl-paste)" 
else
    #echo "$1" >> ~/.cache/log/browsersh.log
    sel "$1"
fi
