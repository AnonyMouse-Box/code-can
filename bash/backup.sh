#!/bin/bash
# gradually building a backup script as it will be useful to have

/source/
/home/user/backup.tar
/home/user/backup.tar.bz2
/home/user/backup.tbz2

echo building tar archive...
tar -cvf /home/user/backup.tar /source/

echo compressing files...
bzip2 -zvk backup.tar

echo testing integrity...
bzip2 -t backup.tar.bz2

