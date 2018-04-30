#!/bin/bash
# gradually building a backup script as it will be useful to have

SRC=/source
BAK=/tmp/backup
MBK=/tmp/backup-$(date +%b)
WBK=/tmp/backup-$(date +%d)
DBK=/tmp/backup-$(date +%a)

echo building tar archive...
tar -cvf $BAK.tar $SRC
echo \n

echo compressing files...
bzip2 -zvk $BAK.tar
echo \n

echo testing integrity...
bzip2 -t $BAK.tar.bz2
echo \n

# when I've figued out how to read the integrity output I'll split it with an if statement here

echo constructing backup schema...
echo creating daily backup...
cp $BAK.tar.bz2 $DBK.tbz2
echo \n
echo copying daily to server...
rsync $DBK.tbz2

echo creating weekly backup...
cp $BAK.tar.bz2 $WBK.tbz2
echo creating monthly backup...
cp $BAK.tar.bz2 $MBK.tbz2
echo \n
