#!/bin/bash
# gradually building a backup script as it will be useful to have

echo building tar archive...
tar -cvf /home/user/backup.tar /source/

echo compressing files...
bzip2 -zvk backup.tar
