#!/bin/bash
# gradually building a backup script as it will be useful to have

SRC=/source/
BAK=/home/user/backup-$(date +%Y%m%d)

echo building tar archive...
tar -cvf $BAK.tar $SRC

echo compressing files...
bzip2 -zvk $BAK.tar

echo testing integrity...
bzip2 -t $BAK.tar.bz2

# when I've figued out how to read the integrity output I'll split it with an if statement here

echo renaming file...
mv $BAK.tar.bz2 $BAK.tbz2
