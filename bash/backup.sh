#!/bin/bash
# gradually building a backup script as it will be useful to have

SRC="/home"
LOG="/tmp/backup.txt"
BAK="/tmp/backup"
MBK="/tmp/backup-$(date +%b)"
WBK="/tmp/backup-$(date +%d)"
DBK="/tmp/backup-$(date +%a)"

echo "backup process begun $(date +%c):" >> $LOG

echo "building tar archive..." >>$LOG
tar -cvf $BAK.tar $SRC >> $LOG
echo \n  >> $LOG

echo "compressing files..." >> $LOG
bzip2 -zvk $BAK.tar >> $LOG
echo \n >> $LOG

echo "testing integrity..." >> $LOG
bzip2 -t $BAK.tar.bz2 >> $LOG
echo \n >> $LOG

# when I've figued out how to read the integrity output I'll split it with an if statement here
# runs every day

echo "constructing backup schema..." >> $LOG
echo "creating daily backup..." >> $LOG
cp $BAK.tar.bz2 $DBK.tbz2 >> $LOG
echo \n >> $LOG

echo "copying daily to server..." >> $LOG
rsync $DBK.tbz2 >> $LOG
echo \n >> $LOG

if [ "$(date +%d)" == "01" ] || [ "$(date +%d)" == "08" ] || [ "$(date +%d)" == "15" ] || [ "$(date +%d)" == "22" ] || [ "$(date +%d)" == "29" ]
  then
    # runs every 1st, 8th, 15th, 22nd and 29th
    
    echo "creating weekly backup..." >> $LOG
    cp $BAK.tar.bz2 $WBK.tbz2 >> $LOG
    echo \n >> $LOG
    
    echo "copying weekly to server..." >> $LOG
    rsync $WBK.tbz2 >> $LOG
    echo \n >> $LOG
    
    if [ "$(date +%d)" == "01" ]
      then
        echo "creating monthly backup..." >> $LOG
        cp $BAK.tar.bz2 $MBK.tbz2 >> $LOG
        echo \n >> $LOG
        
        echo "copying monthly to server..." >> $LOG
        rsync $MBK >> $LOG
        echo \n >> $LOG
    fi
fi

echo "cleaning up temporary files..." >> $LOG
rm $BAK.tar $BAK.tar.bz2 $DBK.tbz2 $WBK.tbz2 $MBK.tbz2 >> $LOG
echo \n >> $LOG

echo "backup complete $(date +%c)." >> $LOG
echo \n >> $LOG
echo \n >> $LOG
