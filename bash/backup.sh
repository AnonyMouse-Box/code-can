#!/bin/bash
# gradually building a backup script as it will be useful to have -vrpEogtSxhm

t="0"
USR="$USER"                               # $2
HST="127.0.0.1"                           # $3
SRC="$1"
DST="/mnt/backup"                         # $4
LOG="/home/$USR/backup-$(date +%a).log"   # $5
BAK="/tmp/backup"
MBK="/tmp/backup-$(date +%b)"
WBK="/tmp/backup-$(date +%d)"
DBK="/tmp/backup-$(date +%a)"

echo "preparing variables.." &> $LOG
if [ $# -lt "2"];
  if [ $# == "0" ];
    then
      SRC="/home"
  fi
fi

if [ $USER == "root" ];
  then
    USR="admin"
    if [ ! -d /home/admin ];
      then
        mkdir -p /home/admin
    fi
fi
echo &>> $LOG

echo "backup process begun $(date +%c):" &>> $LOG

while [ $t -lt "3" ]; do
  
  echo "building archive..." &>> $LOG
  tar --exclude="$LOG" -cpvf $BAK.tar $SRC &>> $LOG
  echo &>> $LOG
  
  echo "compressing files..." &>> $LOG
  bzip2 -zvk $BAK.tar &>> $LOG
  echo &>> $LOG
  
  echo "testing integrity..." &>> $LOG
  bzip2 -vt $BAK.tar.bz2 &>> $LOG
  TST="$(tail -n 1 $LOG)"
  echo &>> $LOG  

  if [ "$TST" != "  $BAK.tar.bz2: ok" ];
    then
      echo "failed integrity test" &>> $LOG
      let "t += 1"
      rm -v $BAK.tar $BAK.tar.bz2 &>> $LOG
      sleep 300
      echo "retrying..." &>> $LOG
      echo &>> $LOG  
      continue
  fi
  
  echo "constructing backup schema..." &>> $LOG
  echo "creating daily backup..." &>> $LOG
  cp -v $BAK.tar.bz2 $DBK.tbz2 &>> $LOG
  echo &>> $LOG
  
  echo "copying daily to server..." &>> $LOG
  rsync -htvpEogSm $DBK.tbz2 $USR@$HST:$DST &>> $LOG
  echo &>> $LOG
  
  if [ "$(date +%d)" == "01" ] || [ "$(date +%d)" == "08" ] || [ "$(date +%d)" == "15" ] || [ "$(date +%d)" == "22" ] || [ "$(date +%d)" == "29" ];
    then    
      echo "creating weekly backup..." &>> $LOG
      cp -v $BAK.tar.bz2 $WBK.tbz2 &>> $LOG
      echo &>> $LOG
      
      echo "copying weekly to server..." &>> $LOG
      rsync -htvpEogSm $WBK.tbz2 $USR@$HST:$DST &>> $LOG
      echo &>> $LOG
      
      if [ "$(date +%d)" == "01" ];
        then
          echo "creating monthly backup..." &>> $LOG
          cp -v $BAK.tar.bz2 $MBK.tbz2 &>> $LOG
          echo &>> $LOG
          
          echo "copying monthly to server..." &>> $LOG
          rsync -htvpEogSm $MBK.tbz2 $USR@$HST:$DST &>> $LOG
          echo &>> $LOG
      fi
  fi
  
  echo "cleaning up temporary files..." &>> $LOG
  rm -v $BAK.tar $BAK.tar.bz2 $DBK.tbz2 $WBK.tbz2 $MBK.tbz2 &>> $LOG
  echo &>> $LOG
  
  echo "backup complete :) $(date +%c)." &>> $LOG
  echo &>> $LOG
  echo &>> $LOG
  exit 0
done    

if [ $t == "3" ];
  then
    echo "failed too many times..." &>> $LOG
    echo "removing files..." &>> $LOG
    rm -v $BAK.tar $BAK.tar.bz2 &>> $LOG
    echo "backup aborted :( $(date +%c)." &>> $LOG
    echo &>> $LOG
    echo &>> $LOG
    exit 1
fi
