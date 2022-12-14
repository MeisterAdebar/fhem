#!/bin/bash

# parameter(s) <mountpoint1> <backupdirectory>
# example: "/bli/backup.sh /mnt/bla /blub/Backups &"
mopt=$1
bud=$2
mo="mount $1"
umo="umount $1"

if $mo; then
    err=$?
    echo "$(date +"%Y.%m.%d %T") $err: mount successful, run backup command"

    files=$(ls ${mopt}${bud})

    for file in $files; do
        arr+=("@${mopt}${bud}/$file")
    done

    perl fhem.pl 7072 "backup"
    err=$?
    echo "$(date +"%Y.%m.%d %T") $err: backup command"
    sleep 1
    err=$?
    echo "$(date +"%Y.%m.%d %T") $err: sleep 1"    
    inotifywait -e close_write ${mopt}${bud}/*.tar.gz ${arr[*]}
    err=$?
    echo "$(date +"%Y.%m.%d %T") $err: inotify"
fi

if
    [ $err -eq "0" ]
then
    sync
    err=$?
    echo "$(date +"%Y.%m.%d %T") $err: sync"
    sleep 3
    err=$?
    echo "$(date +"%Y.%m.%d %T") $err: sleep 3"
    $umo
    err=$?
    echo "$(date +"%Y.%m.%d %T") $err: umount"
fi
