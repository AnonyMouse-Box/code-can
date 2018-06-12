#!/bin/bash
# backup-0.sh [remote IP]

function IsAlive(){
  ping -c 5 '$1' &>> [log file]
  for i in {1..12};
    then
      if [ '$?' != '0' ];
        then
          sleep 300
          ping -c 5 '$1' &>> '$TMP'
        else
          exit 0
      done
  done
  exit 1
}

ERR='False'
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
        if [ $USER == 'root' ];
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
    echo 'syntax error, exiting' &>> '$TMP'
    ;;
  '1')
    echo 'could not connect to remote server' &>> '$TMP'
    ;;
  *)
    echo 'critical failure: undesignated error' &>> '$TMP'
    exit 1
    ;;
esac
