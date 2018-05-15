#!/bin/bash
# gradually building a backup script as it will be useful to have -vrpEogtSxhm
# backup.sh Files User Remote Folder Log

t="0"
USR="$2"
HST="$3"
SRC="$1"
DST="$4"
FOL="$5"

if [ $# -lt "2" ];
  then
    USR="$USER"
fi

if [ $USER == "root" ];
  then
    USR="admin"
fi

if [ $# -lt "5" ];
  then
    FOL="/home/$USR/"
fi

if [ ! -d $FOL ];
  then
    mkdir -p $FOL
fi

LOG="$FOL/backup-$(date +%a.log)"

echo "preparing variables.." &> $LOG

if [ ! -d $USER@$HST:$DST ];
  then
    mkdir -p $USER@$HST:$DST
fi

if [ $# == "0" ];
  then
    SRC="/home"
fi
                
if [ $# -lt "3" ];
  then
    HST="127.0.0.1"
fi
       
if [ $# -lt "4" ];
  then 
    DST="/mnt/backup"
fi

BAK="/tmp/backup"
MBK="/tmp/backup-$(date +%b)"
WBK="/tmp/backup-$(date +%d)"
DBK="/tmp/backup-$(date +%a)"

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

  if [ $? != "0" ];
    then
      echo &>> $LOG
      echo "failed integrity test" &>> $LOG
      let "t += 1"
      rm -v $BAK.tar $BAK.tar.bz2 &>> $LOG
      sleep 300
      echo "retrying..." &>> $LOG
      echo &>> $LOG  
      continue
  fi
  
  echo &>> $LOG  
  
  echo "constructing backup schema..." &>> $LOG
  echo "creating daily backup..." &>> $LOG
  cp -v $BAK.tar.bz2 $DBK.tbz2 &>> $LOG
  echo &>> $LOG
  
  echo "copying daily to server..." &>> $LOG
  rsync -htvpEogSm $DBK.tbz2 $USER@$HST:$DST &>> $LOG
  echo &>> $LOG
  
  if [ $(date +%d) == "01" ] || [ $(date +%d) == "08" ] || [ $(date +%d) == "15" ] || [ $(date +%d) == "22" ] || [ $(date +%d) == "29" ];
    then    
      echo "creating weekly backup..." &>> $LOG
      cp -v $BAK.tar.bz2 $WBK.tbz2 &>> $LOG
      echo &>> $LOG
      
      echo "copying weekly to server..." &>> $LOG
      rsync -htvpEogSm $WBK.tbz2 $USER@$HST:$DST &>> $LOG
      echo &>> $LOG
      
      if [ $(date +%d) == "01" ];
        then
          echo "creating monthly backup..." &>> $LOG
          cp -v $BAK.tar.bz2 $MBK.tbz2 &>> $LOG
          echo &>> $LOG
          
          echo "copying monthly to server..." &>> $LOG
          rsync -htvpEogSm $MBK.tbz2 $USER@$HST:$DST &>> $LOG
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
  break
done    

if [ $t == "3" ];
  then
    echo "failed too many times..." &>> $LOG
    echo "removing files..." &>> $LOG
    rm -v $BAK.tar $BAK.tar.bz2 &>> $LOG
    echo "backup aborted :( $(date +%c)." &>> $LOG
    echo &>> $LOG
    echo &>> $LOG
    exit 2
fi
