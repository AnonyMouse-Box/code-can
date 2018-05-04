#!/bin/bash
# gradually building a backup script as it will be useful to have -vrpEogtSxhm

USR="$USER"
HST="127.0.0.1"
SRC="$1"
DST="/mnt/backup"
LOG="/home/$USR/backup.log"
BAK="/tmp/backup"
MBK="/tmp/backup-$(date +%b)"
WBK="/tmp/backup-$(date +%d)"
DBK="/tmp/backup-$(date +%a)"

echo "preparing variables.." >> $LOG
if [ "$#" == "0" ];
  then
    SRC="/home"
fi

if [ "$USER" == "root" ];
  then
    USR="admin"
    if [ ! -d /home/admin ];
      then
        mkdir -p /home/admin
    fi
fi
echo "\n"

echo "backup process begun $(date +%c):" >> $LOG

echo "building tar archive..." >> $LOG
tar --exclude="$LOG" -cvf $BAK.tar $SRC >> $LOG
echo "\n"  >> $LOG

echo "compressing files..." >> $LOG
bzip2 -zvk $BAK.tar >> $LOG
echo "\n" >> $LOG

echo "testing integrity..." >> $LOG
bzip2 -vt $BAK.tar.bz2 >> $LOG
echo "\n" >> $LOG

# when I've figued out how to read the integrity output I'll split it with an if statement here

echo "constructing backup schema..." >> $LOG
echo "creating daily backup..." >> $LOG
cp -v $BAK.tar.bz2 $DBK.tbz2 >> $LOG
echo "\n" >> $LOG

echo "copying daily to server..." >> $LOG
rsync -htyv $DBK.tbz2 $USR@$HST:$DST >> $LOG
echo "\n" >> $LOG

if [ "$(date +%d)" == "01" ] || [ "$(date +%d)" == "08" ] || [ "$(date +%d)" == "15" ] || [ "$(date +%d)" == "22" ] || [ "$(date +%d)" == "29" ];
  then    
    echo "creating weekly backup..." >> $LOG
    cp -v $BAK.tar.bz2 $WBK.tbz2 >> $LOG
    echo "\n" >> $LOG
    
    echo "copying weekly to server..." >> $LOG
    rsync -htyv $WBK.tbz2 $USR@$HST:$DST >> $LOG
    echo "\n" >> $LOG
    
    if [ "$(date +%d)" == "01" ];
      then
        echo "creating monthly backup..." >> $LOG
        cp -v $BAK.tar.bz2 $MBK.tbz2 >> $LOG
        echo "\n" >> $LOG
        
        echo "copying monthly to server..." >> $LOG
        rsync -htyv $MBK.tbz2 $USR@$HST:$DST >> $LOG
        echo "\n" >> $LOG
    fi
fi

echo "cleaning up temporary files..." >> $LOG
rm -v $BAK.tar $BAK.tar.bz2 $DBK.tbz2 $WBK.tbz2 $MBK.tbz2 >> $LOG
echo "\n" >> $LOG

echo "backup complete $(date +%c)." >> $LOG
echo "\n" >> $LOG
echo "\n" >> $LOG
