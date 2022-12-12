#!/bin/bash

# parameter(s) <mountpoint1> <backupdirectory>
# example: "/opt/fhem/www/scripts/backup.sh /mnt/FRITZNAS /FHEM/Backups &"

mopt=$1
bud=$2
mo="mount $1"
umo="umount $1"

if $mo; then
    echo "$?, mount erfolgreich, führe backup Befehl aus"
    perl fhem.pl 7072 "backup"
    echo "$?, backup Befehl ausgeführt"
fi

inotifywait -e close_write ${mopt}${bud}
echo "$?, inotify"

if
    [ $? -eq "0" ]
then
    $umo
    echo "$?, unmount"
fi
