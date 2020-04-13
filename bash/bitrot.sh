#!/bin/bash

function timestamp() {
  while IFS= read -r line; do
    echo [$(date +"%F %T.%N")] $line
  done
}
# redirect the stdout/stderr to screen AND log file
LOG="/var/log/usr/bitrot.log"
DIR=$(mktemp -d)
if [ ${#DIR} == 19 ]; then
  mkfifo ${DIR}/$$-err ${DIR}/$$-out
  # to merge stdout/stderr to log file AND screen
  ( exec tee -a ${LOG} < ${DIR}/$$-out ) &
  ( exec tee -a ${LOG} < ${DIR}/$$-err >&2 ) &
  # redirect stdout/stderr
  exec 1> >( timestamp ${DIR}/$$-out > ${DIR}/$$-out )
  exec 2> >( timestamp ${DIR}/$$-err > ${DIR}/$$-err )
  
  START=$(date +%s)
  echo ">>>START OF OUTPUT<<<"
  
  DSK=$1
  badblocks -svw $DSK
  mkfs.btrfs $DSK
  MNT=$(mktemp -d)
  mount $DSK $MNT
  RAN=${MNT}random.bin
  touch $RAN
  dd if=/dev/urandom bs=32 count=1 | openssl enc -aes128 -in /dev/zero -out $RAN -pass stdin
  btrfs scrub start -Bd $MNT
  umount $DSK
  rm -R $MNT
  
  echo ">>>END OF OUTPUT<<<"
  END=$(date +%s)
  
  # calculate time taken
  SECONDS=$(echo "$END - $START" | bc)
  if [ $SECONDS > 3600 ]; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)" 
  elif [ $SECONDS > 60 ]; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $minutes minute(s) and $seconds second(s)"
  else
    echo "Completed in $SECONDS seconds"
  fi
  
  # remove temporary directory
  rm ${DIR}/$$-err ${DIR}/$$-out
  rm -R ${DIR}
  exit 0
fi
exit 1
