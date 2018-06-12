#!/bin/bash
# backup2.sh [remote IP]

function IsAlive(){
  ping -c 5 '$1'
  for i in {1..12};
    then
      if [ $? != 0 ];
        then
          sleep 300
          ping -c 5 '$1'
        else
          exit 0
      done
  done
  exit 1
}

for i in {1..3};
  then
    IP='$1'
    IsAlive '$IP'
    if [ '$?' == '1' ];
      then
        ERR='0'
        continue
    fi
done

case $ERR in
  '0')
    echo 'could not connect to remote server' &>> [log file]
    ;;
  *)
    echo 'critical failure: undesignated error' &>> [log file]
    exit 1
    ;;
  esac
