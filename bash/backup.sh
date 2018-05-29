#!/bin/bash
# backup.sh Files User Remote Folder Log

function PrintBlank(){
 echo &>> $LOG
}

function DirNotExist(){
 if [ ! -d $1 ];
  then
   BOO=true
  else
   BOO=false
 fi
}

function VarEqualThree(){
 if [ $1 == 3 ];
  then
   BOO=true
  else
   BOO=false
 fi
}

function ExitNotZero(){
 if [ $EXI != "0" ];
  then
   BOO=true
  else
   BOO=false
 fi
}

ARG=$#
NOW=$(date +%c)
USR="$2"
HST="$3"
SRC="$1"
DST="$4"
FOL="$5"

for a in {1..6};
 case $ARG in
  0)
   SRC="/home"
   ;;
  1)
   USR="$USER"
  ;;
  2)
   HST="127.0.0.1"
   ;;
  3)
   DST="/mnt/backup"
  ;;
  4)
   if [ $USER == "root" ];
    then
     USR="admin"
   fi
   FOL="/home/$USR/"
  ;;
  5)
  ;;
  *)
   echo "syntax error, exiting"
   exit 1
  ;;
 esac
 if [ $ARG != 5 ];
  then
   let "ARG += 1"
 fi
done

DirNotExist $FOL
if [ $BOO == true ];
  then
    mkdir -p $FOL
fi

LOG="$FOL/backup-$(date +%d).log"

echo "preparing variables.." &> $LOG

DirNotExist $USER@$HST:$DST
if [ $BOO == true ];
  then
    mkdir -p $USER@$HST:$DST
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

PrintBlank

echo "backup process begun $NOW:" &>> $LOG

for i in {1..3};
  do
    
    for t in {1..3};
      do
        echo "building archive..." &>> $LOG
        tar --exclude="$LOG" -cpvf $BAK.tar $SRC &>> $LOG
        
        EXI="$?"
        ExitNotZero
        if [ $BOO == true ];
          then
            PrintBlank
            echo "archive failed" &>> $LOG
            let "tar += 1"
            sleep 300
            echo "retrying..." &>> $LOG
            PrintBlank  
            continue
        fi
        break
    done
    
    VarEqualThree $tar
    if [ $BOO == true ];
      then
        break
    fi
    
    PrintBlank
      
    for c in {1..3};
      do
        echo "compressing files..." &>> $LOG
        bzip2 -zvk $BAK.tar &>> $LOG
        
        EXI="$?"
        ExitNotZero
        if [ $BOO == true ];
          then
            PrintBlank
            echo "compress failed" &>> $LOG
            let "compress += 1"
            sleep 300
            echo "retrying..." &>> $LOG
            PrintBlank  
            continue
        fi
        break
    done
    
    VarEqualThree $compress
    if [ $BOO == true ];
      then
        break
    fi
    
    PrintBlank
    
    echo "testing integrity..." &>> $LOG
    bzip2 -vt $BAK.tar.bz2 &>> $LOG
  
    EXI="$?"
    ExitNotZero
    if [ $BOO == true ];
      then
        PrintBlank
        echo "failed integrity test" &>> $LOG
        rm -v $BAK.tar $BAK.tar.bz2 &>> $LOG
        sleep 300
        echo "retrying..." &>> $LOG
        tar="0"
        compress="0"
        PrintBlank  
        continue
    fi
    
    PrintBlank  
    
    echo "constructing backup schema..." &>> $LOG
    
    echo "creating daily backup..." &>> $LOG
    cp -v $BAK.tar.bz2 $DBK.tbz2 &>> $LOG
    PrintBlank
    
    for d in {1..3};
      do
        echo "copying daily to server..." &>> $LOG
        rsync -htvpEogSm $DBK.tbz2 $USER@$HST:$DST &>> $LOG
        
        EXI="$?"
        ExitNotZero
        if [ $BOO == true ];
          then
            PrintBlank
            echo "failed sync" &>> $LOG
            let "daily += 1"
            sleep 300
            echo "retrying..." &>> $LOG
            PrintBlank  
            continue
        fi
        break
    done
    
    VarEqualThree $daily
    if [ $BOO == true ];
      then
        break
    fi
    
    echo &>> $LOG
    
    case $(date +%d) in
      01|08|15|22|29)
        echo "creating weekly backup..." &>> $LOG
        cp -v $BAK.tar.bz2 $WBK.tbz2 &>> $LOG
        PrintBlank
        
        for w in {1..3};
          do
            echo "copying weekly to server..." &>> $LOG
            rsync -htvpEogSm $WBK.tbz2 $USER@$HST:$DST &>> $LOG
            
            EXI="$?"
            ExitNotZero
            if [ $BOO == true ];
              then
                PrintBlank
                echo "failed sync" &>> $LOG
                let "weekly += 1"
                sleep 300
                echo "retrying..." &>> $LOG
                PrintBlank  
                continue
            fi
            break
        done
    
        VarEqualThree $weekly
        if [ $BOO == true ];
         then
            break
        fi
    
        PrintBlank
        
        if [ $(date +%d) == "01" ];
          then
            echo "creating monthly backup..." &>> $LOG
            cp -v $BAK.tar.bz2 $MBK.tbz2 &>> $LOG
            PrintBlank
            
            for m in {1..1};
              do
                echo "copying monthly to server..." &>> $LOG
                rsync -htvpEogSm $MBK.tbz2 $USER@$HST:$DST &>> $LOG
                
                EXI="$?"
                ExitNotZero
                if [ $BOO == true ];
                  then
                    PrintBlank
                    echo "failed sync" &>> $LOG
                    let "monthly += 1"
                    sleep 300
                    echo "retrying..." &>> $LOG
                    PrintBlank  
                    continue
                fi
                break
            done
    
            VarEqualThree $monthly
            if [ $BOO == true ];
              then
                break
            fi
    
            PrintBlank
    
        fi
        ;;
      *)
        ;;
    esac
    
    echo "cleaning up temporary files..." &>> $LOG
    rm -v $BAK.tar $BAK.tar.bz2 $DBK.tbz2 $WBK.tbz2 $MBK.tbz2 &>> $LOG
    PrintBlank
    
    echo "backup complete :) $NOW." &>> $LOG
    PrintBlank
    PrintBlank
    exit 0
done    

echo "failed too many times..." &>> $LOG
echo "removing files..." &>> $LOG
rm -v $BAK.tar $BAK.tar.bz2 $DBK.tbz2 $WBK.tbz2 $MBK.tbz2 &>> $LOG
echo "backup aborted :( $(date +%c)." &>> $LOG
PrintBlank
PrintBlank
exit 1
