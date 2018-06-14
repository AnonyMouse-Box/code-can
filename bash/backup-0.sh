#!/bin/bash
# backup-0.sh [backup source] [user] [remote IP] [destination folder] [log folder]

function DirExist(){
  if [ ! -d '$1' ];
    then
      return 1
    else
      return 0
  fi
}

function CreateDir(){
  mkdir -p '$1'
  echo
}

function IsAlive(){
  ping -c 5 '$1'
  echo
  for i in {1..12};
    then
      if [ '$?' != '0' ];
        then
          sleep 300
          ping -c 5 '$1'
          echo
        else
          return 0
      fi
  done
  return 1
}

ERR='false'

DirExist '/tmp'
if [ '$?' != '0' ];
  then
    CreateDir '/tmp'
fi

if [ '$?' != '0' ];
  then
    ERR='2'
fi

TMP='/tmp/backup.log'

exec 1<&-
exec 2<&-
exec 1<>$TMP
exec 2>&1

echo 'initializing'

ARG='$#'
NOW='$(date +%c)'
USR='$2'
HST='$3'
SRC='$1'
DST='$4'
FOL='$5'

for a in {1..6};
  do
    case '$ARG' in
      '0')
        SRC='/home'
      ;;
      '1')
        USR='$USER'
      ;;
      '2')
        HST='127.0.0.1'
      ;;
      '3')
        DST='/mnt/backup'
      ;;
      '4')
        if [ '$USER' == 'root' ];
          then
            USR='admin'
        fi
        FOL='/home/$USR/log'
      ;;
      '5')
      ;;
      *)
        ERR='0'
        break
      ;;
    esac
    if [ '$ARG' != '5' ];
      then
        let 'ARG += 1'
    fi
done

if [ '$ERR' != 'false' ];
  then
    echo '$NOW'
    echo 'startup error: exiting script'
    echo
    echo
    exit 1
fi

LOG='$FOL/backup-$(date +%d).log'
BAK='/tmp/backup'
MBK='/tmp/backup-$(date +%b)'
WBK='/tmp/backup-$(date +%d)'
DBK='/tmp/backup-$(date +%a)'
daily='0'
weekly='0'
monthly='0'
tar='0'
compress='0'
copy='0'
integrity='0'

PrintBlank

echo 'backup process begun $NOW:'
echo

for i in {1..3};
  then
    IsAlive '$HST'
    if [ '$?' != '0' ];
      then
        ERR='1'
        echo '$NOW'
        echo 'no response from $HST'
        echo
        continue
    fi
done

case $ERR in
  '0')
    echo 'syntax error, exiting'
    echo
    ;;
  '1')
    echo 'could not connect to remote server, exiting'
    echo
    ;;
  '2')
    echo 'could not create folder, exiting'
    echo
    ;;
  *)
    echo 'critical failure: undesignated error, exiting'
    echo
    echo
    exit 1
    ;;
esac

echo 'backup aborted $NOW.'
echo
echo
exit 1
