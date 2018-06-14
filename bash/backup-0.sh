#!/bin/bash
# backup-0.sh [backup source] [user] [remote IP] [destination folder] [log folder]

function DirExist(){
  if [ ! -d "$1" ];
    then
      return 1
    else
      return 0
  fi
}

function IsAlive(){
  ping -c 5 '$1'
  for i in {1..12};
    then
      if [ '$?' != '0' ];
        then
          sleep 300
          ping -c 5 '$1'
        else
          return 0
      fi
  done
  return 1
}

ERR='false'

DirNotExist '/tmp'
if [ '$?' == '1' ];
  then
    CreateDir '/tmp'
fi

if [ '$?' == '1' ];
  then
    ERR='2'
fi

TMP='/tmp/backup.log'

exec 1<&-
exec 2<&-
exec 1<>$TMP
exec 2>&1

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
    echo 'startup error'
    exit 1
fi

for i in {1..3};
  then
    IsAlive '$HST'
    if [ '$?' == '1' ];
      then
        ERR='1'
        continue
    fi
done

case $ERR in
  '0')
    echo 'syntax error, exiting'
    ;;
  '1')
    echo 'could not connect to remote server'
    ;;
  '2')
    echo 'could not create folder'
    ;;
  *)
    echo 'critical failure: undesignated error'
    exit 1
    ;;
esac
