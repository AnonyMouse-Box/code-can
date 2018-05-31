#!/bin/bash
# backup.sh Files User Remote Folder Log

cd /

function DirNotExist(){
  if [ ! -d "$1" ];
    then
      BOO="true"
    else
      BOO="false"
  fi
}

function CreateDir(){
  mkdir -p "$1"
}

DirNotExist "tmp"
if [ $BOO == "true" ];
  then
    CreateDir "tmp"
fi

TMP="/tmp/backup.log"

echo "preparing system.." &> "$TMP"

function PrintBlank(){
  echo &>> "$TMP"
}

function PrintBlankLog(){
  echo &>> "$LOG"
}

function VarEqualThree(){
  if [ "$1" == "3" ];
    then
      BOO="true"
    else
      BOO="false"
  fi
}

function ExitNotZero(){
  if [ "$EXI" != "0" ];
    then
      BOO="true"
    else
      BOO="false"
  fi
}

function Fail(){
  let "$1 += 1"
  sleep 300
  echo "retrying..." &>> "$TMP"
  PrintBlank
}

function Archive(){
  echo "building archive..." &>> "$TMP"
  tar --exclude="$3" -cpvf "$2" "$1" &>> "$TMP"
  PrintBlank
}

function Compress(){
  echo "compressing file..." &>> "$TMP"
  bzip2 -zvk "$1.tar" &>> "$TMP"
  PrintBlank
}

function TestIntegrity(){
  echo "testing integrity..." &>> "$TMP"
  bzip2 -vt "$1" &>> "$TMP"
  PrintBlank
}

function IntegrityCleanup(){
  rm -v "$1.tar" "$1.tar.bz2" &>> "$TMP"
  tar="0"
  compress="0"
}

function CopyBackup(){
  echo "finalizing backup..." &>> "$TMP"
  cp -v "$1" "$2" &>> "$TMP"
  PrintBlank
}

function CopyLog(){
  echo "copying log..." &>> "$TMP"
  cp -v "$TMP" "$LOG" &>> "$LOG"
  PrintBlankLog
}

function RemoveTemps(){
  echo "cleaning up temporary files..." &>> "$LOG"
  rm -v "$BAK.tar" "$BAK.tar.bz2" "$DBK.tbz2" "$WBK.tbz2" "$MBK.tbz2" "$TMP" &>> "$LOG"
  PrintBlankLog
}

ARG="$#"
NOW="$(date +%c)"
USR="$2"
HST="$3"
SRC="$1"
DST="$4"
FOL="$5"

for a in {1..6};
  do
    case "$ARG" in
      "0")
        SRC="/home"
      ;;
      "1")
        USR="$USER"
      ;;
      "2")
        HST="127.0.0.1"
      ;;
      "3")
        DST="/mnt/backup"
      ;;
      "4")
        if [ $USER == "root" ];
          then
            USR="admin"
        fi
        FOL="/home/$USR/log"
      ;;
      "5")
      ;;
      *)
        echo "syntax error, exiting" &>> "$TMP"
        exit 1
      ;;
    esac
    if [ "$ARG" != "5" ];
      then
        let "ARG += 1"
    fi
done

DirNotExist "$FOL"
if [ "$BOO" == "true" ];
  then
    CreateDir "$FOL"
fi

LOG="$FOL/backup-$(date +%d).log"
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
integrity="0"

PrintBlank

echo "backup process begun $NOW:" &>> "$TMP"

for i in {1..3};
  do
    for t in {1..3};
      do
        Archive "$SRC" "$BAK.tar" "$FOL"
        
        EXI="$?"
        ExitNotZero
        if [ "$BOO" == "true" ];
          then
            echo "archive failed" &>> "$TMP"
            Fail "tar"
            continue
        fi
        break
    done

    VarEqualThree "$tar"
    if [ "$BOO" == "true" ];
      then
        break
    fi
    
    for c in {1..3};
      do
        Compress "$BAK.tar"
        
        EXI="$?"
        ExitNotZero
        if [ "$BOO" == "true" ];
          then
            echo "compress failed" &>> "$TMP"
            Fail "compress" 
            continue
        fi
        break
    done
    
    VarEqualThree "$compress"
    if [ "$BOO" == "true" ];
      then
        break
    fi
    
    TestIntegrity "$BAK.tar.bz2"
    
    EXI="$?"
    ExitNotZero
    if [ "$BOO" == "true" ];
      then
        echo "failed integrity test" &>> "$TMP"
        Fail "integrity"
        IntegrityCleanup "$BAK"
        continue
    fi  
    
    echo "constructing backup schema..." &>> "$TMP"

for c in {1..3};
do
echo "creating daily backup..." &>> "$TMP"
CopyBackup "$BAK.tar.bz2" "$DBK.tbz2"

EXI="$?"
ExitNotZero
if [ "$BOO" == "true" ];
then
echo "copy failed" &>> "$TMP"
Fail "copy"
continue
fi
break
done

VarEqualThree "$copy"
if [ "$BOO" == "true" ];
then
break
fi

for d in {1..3};
do
echo "copying daily to server..." &>> "$TMP"
rsync -htvpEogSm "$DBK.tbz2" "$USER@$HST:$DST" &>> "$TMP"
PrintBlank

EXI="$?"
ExitNotZero
if [ "$BOO" == "true" ];
then
echo "failed sync" &>> "$TMP"
Fail "daily"
continue
fi
break
done

VarEqualThree "$daily"
if [ "$BOO" == "true" ];
then
break
fi

case "$(date +%d)" in
"01"|"08"|"15"|"22"|"29")
copy="0"
for c in {1..3};
do
echo "creating weekly backup..." &>> "$TMP"
CopyBackup "$BAK.tar.bz2" "$WBK.tbz2"

EXI="$?"
ExitNotZero
if [ "$BOO" == "true" ];
then
echo "copy failed" &>> "$TMP"
Fail "copy"
continue
fi
break
done

VarEqualThree "$copy"
if [ "$BOO" == "true" ];
then
break
fi

for w in {1..3};
do
echo "copying weekly to server..." &>> "$TMP"
rsync -htvpEogSm "$WBK.tbz2" "$USER@$HST:$DST" &>> "$TMP"
PrintBlank

EXI="$?"
ExitNotZero
if [ "$BOO" == "true" ];
then
echo "failed sync" &>> "$TMP"
Fail "weekly" 
continue
fi
break
done

VarEqualThree "$weekly"
if [ "$BOO" == "true" ];
then
break
fi

if [ "$(date +%d)" == "01" ];
then
copy="0"
for c in {1..3};
do
echo "creating monthly backup..." &>> "$TMP"
CopyBackup "$BAK.tar.bz2" "$MBK.tbz2"

EXI="$?"
ExitNotZero
if [ "$BOO" == "true" ];
then
echo "copy failed" &>> "$TMP"
Fail "copy"
continue
fi
break
done

VarEqualThree "$copy"
if [ "$BOO" == "true" ];
then
break
fi

for m in {1..3};
do
echo "copying monthly to server..." &>> "$TMP"
rsync -htvpEogSm "$MBK.tbz2" "$USER@$HST:$DST" &>> "$TMP"
PrintBlank

EXI="$?"
ExitNotZero
if [ "$BOO" == "true" ];
then
echo "failed sync" &>> "$TMP"
Fail "monthly"
continue
fi
break
done

VarEqualThree "$monthly"
if [ "$BOO" == "true" ];
then
break
fi

echo "cleaning up old log files..." &>> "$TMP"
tar="0"
compress="0"
integrity="0"
BLO="$FOL/log-$(date +%b)"
ARC="$FOL/archive/log-$(date +%b).tbz2"

for i in {1..3};
do
for t in {1..3};
do
Archive "$FOL/*.log" "$BLO.tar" "$FOL/archive"

EXI="$?"
ExitNotZero
if [ "$BOO" == "true" ];
then
echo "archive failed" &>> "$TMP"
Fail "tar" 
continue
fi
break
done

VarEqualThree "$tar"
if [ "$BOO" == "true" ];
then
break 2
fi

for c in {1..3};
do
Compress "$BLO.tar"

EXI="$?"
ExitNotZero
if [ "$BOO" == "true" ];
then
echo "compress failed" &>> "$TMP"
Fail "compress"
continue
fi
break
done

VarEqualThree "$compress"
if [ "$BOO" == "true" ];
then
break 2
fi

TestIntegrity "$BLO.tar.bz2"

EXI="$?"
ExitNotZero
if [ "$BOO" == "true" ];
then
echo "failed integrity test" &>> "$TMP"
Fail "integrity"
IntegrityCleanup "$BLO"
continue
fi
break

VarEqualThree "$integrity"
if [ "$BOO" == "true" ];
then
break 2
fi
done

copy="0"
for c in {1..3};
do
echo "moving to archive..." &>> "$TMP"
CopyBackup "$BLO.tar.bz2" "$ARC"

EXI="$?"
ExitNotZero
if [ "$BOO" == "true" ];
then
echo "copy failed" &>> "$TMP"
Fail "copy"
continue
fi
break
done

VarEqualThree "$copy"
if [ "$BOO" == "true" ];
then
break
fi

echo "clearing log folder..." &>> "$TMP"
rm -v "$BLO.tar" "$BLO.tar.bz2" "$BLO.tbz2" "$FOL/*.log" &>> "$TMP"
PrintBlank
fi
;;
*)
;;
esac

CopyLog
RemoveTemps

echo "backup complete :) $NOW." &>> "$LOG"
PrintBlankLog
PrintBlankLog
exit 0
done    

echo "failed too many times..." &>> "$TMP"

CopyLog
RemoveTemps

echo "backup aborted :( $(date +%c)." &>> "$LOG"
PrintBlankLog
PrintBlankLog
exit 1
