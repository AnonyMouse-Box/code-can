#!/bin/bash
# gradually building a backup script as it will be useful to have -vrpEogtSxhm
# backup.sh Files User Remote Folder Log

ARG="$#"

function ARGLessThan(){
 if [ $ARG -lt $1 ];
  then
   BOO=true
  else
   BOO=false
 fi
}

NOW=$(date +%c)
USR="$2"
HST="$3"
SRC="$1"
DST="$4"
FOL="$5"

ARGLessThan 2
if [ BOO == true ];
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
daily="0"
weekly="0"
monthly="0"
tar="0"
compress="0"
copy="0"

echo &>> $LOG

echo "backup process begun $NOW:" &>> $LOG

for i in {1..3};
  do
    
    for t in {1..3};
      do
        echo "building archive..." &>> $LOG
        tar --exclude="$LOG" -cpvf $BAK.tar $SRC &>> $LOG
        
        if [ $? != "0" ];
          then
            echo &>> $LOG
            echo "archive failed" &>> $LOG
            let "tar += 1"
            sleep 300
            echo "retrying..." &>> $LOG
            echo &>> $LOG  
            continue
        fi
        break
    done
    
    if [ $tar == "3" ];
      then
        break
    fi
    
    echo &>> $LOG
      
    for c in {1..3};
      do
        echo "compressing files..." &>> $LOG
        bzip2 -zvk $BAK.tar &>> $LOG
        
        if [ $? != "0" ];
          then
            echo &>> $LOG
            echo "compress failed" &>> $LOG
            let "compress += 1"
            sleep 300
            echo "retrying..." &>> $LOG
            echo &>> $LOG  
            continue
        fi
        break
    done
    
    if [ $compress == "3" ];
      then
        break
    fi
    
    echo &>> $LOG
    
    echo "testing integrity..." &>> $LOG
    bzip2 -vt $BAK.tar.bz2 &>> $LOG
  
    if [ $? != "0" ];
      then
        echo &>> $LOG
        echo "failed integrity test" &>> $LOG
        rm -v $BAK.tar $BAK.tar.bz2 &>> $LOG
        sleep 300
        echo "retrying..." &>> $LOG
        tar="0"
        compress="0"
        echo &>> $LOG  
        continue
    fi
    
    echo &>> $LOG  
    
    echo "constructing backup schema..." &>> $LOG
    
    echo "creating daily backup..." &>> $LOG
    cp -v $BAK.tar.bz2 $DBK.tbz2 &>> $LOG
    echo &>> $LOG
    
    for d in {1..3};
      do
        echo "copying daily to server..." &>> $LOG
        rsync -htvpEogSm $DBK.tbz2 $USER@$HST:$DST &>> $LOG
      
        if [ $? != "0" ];
          then
            echo &>> $LOG
            echo "failed sync" &>> $LOG
            let "daily += 1"
            sleep 300
            echo "retrying..." &>> $LOG
            echo &>> $LOG  
            continue
        fi
        break
    done
    
    if [ $daily == "3" ];
      then
        break
    fi
    
    echo &>> $LOG
    
    case $(date +%d) in
      01|08|15|22|29)
        echo "creating weekly backup..." &>> $LOG
        cp -v $BAK.tar.bz2 $WBK.tbz2 &>> $LOG
        echo &>> $LOG
        
        for w in {1..3};
          do
            echo "copying weekly to server..." &>> $LOG
            rsync -htvpEogSm $WBK.tbz2 $USER@$HST:$DST &>> $LOG
            
            if [ $? != "0" ];
              then
                echo &>> $LOG
                echo "failed sync" &>> $LOG
                let "weekly += 1"
                sleep 300
                echo "retrying..." &>> $LOG
                echo &>> $LOG  
                continue
            fi
            break
        done
    
        if [ $weekly == "3" ];
          then
            break
        fi
    
        echo &>> $LOG
        
        if [ $(date +%d) == "01" ];
          then
            echo "creating monthly backup..." &>> $LOG
            cp -v $BAK.tar.bz2 $MBK.tbz2 &>> $LOG
            echo &>> $LOG
            
            for m in {1..1};
              do
                echo "copying monthly to server..." &>> $LOG
                rsync -htvpEogSm $MBK.tbz2 $USER@$HST:$DST &>> $LOG
                
                if [ $? != "0" ];
                  then
                    echo &>> $LOG
                    echo "failed sync" &>> $LOG
                    let "monthly += 1"
                    sleep 300
                    echo "retrying..." &>> $LOG
                    echo &>> $LOG  
                    continue
                fi
                break
            done
    
            if [ $monthly == "3" ];
              then
                break
            fi
    
            echo &>> $LOG
    
        fi
        ;;
      *)
        ;;
    esac
    
    echo "cleaning up temporary files..." &>> $LOG
    rm -v $BAK.tar $BAK.tar.bz2 $DBK.tbz2 $WBK.tbz2 $MBK.tbz2 &>> $LOG
    echo &>> $LOG
    
    echo "backup complete :) $NOW." &>> $LOG
    echo &>> $LOG
    echo &>> $LOG
    exit 0
done    

echo "failed too many times..." &>> $LOG
echo "removing files..." &>> $LOG
rm -v $BAK.tar $BAK.tar.bz2 $DBK.tbz2 $WBK.tbz2 $MBK.tbz2 &>> $LOG
echo "backup aborted :( $(date +%c)." &>> $LOG
echo &>> $LOG
echo &>> $LOG
exit 1
