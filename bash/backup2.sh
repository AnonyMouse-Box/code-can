#!/bin/bash
# backup2.sh [remote IP]

function IsAlive(){
ping -c 5 "$1"
for i in {1..12};
  then
    if [ $? != 0 ];
      then
        sleep 300
        ping -c 5 "$1"
      else
        exit 0
    done
done
exit 1
}

for i in {1..3};
  then
    IP="$1"
    IsAlive "$IP"
    if [ "$?" == "1" ];
      then
        break
    fi
done
