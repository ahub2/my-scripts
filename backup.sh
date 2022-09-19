#!/usr/bin/env sh
BACKUP_LOC="/media/SEAGATE/HOME_BACKUP/"
DIR="$HOME/"
EXCLUDE_CONF="$HOME/.config/rsync-exclude.conf"

EXCL_INCL="--exclude-from=$EXCLUDE_CONF"

if [ "$1" = "-r" ]; then
    notify-send "backup.sh" "restoring from backup"
    rsync -ru $EXCL_INCL "$BACKUP_LOC" "$DIR" 
else

    notify-send "backup.sh" "performing backup"
    if [ -d $BACKUP_LOC ]; then 
        rsync -arP --delete $EXCL_INCL "$DIR" "$BACKUP_LOC"
    else
        notify-send "backup.sh" "backup location not found"
    fi

fi

sync
