#!/bin/bash

FILE=$1
DIGEST=$2
PASS='false'

function timestamp() {
  while IFS= read -r line; do
    echo [$(date +"%F %T.%N")] $line
  done
}
# redirect the stdout/stderr to screen AND log file
LOG="/var/log/usr/file.log"
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
  
  function testKeys() {
    gpg --verify $DIGEST &> ${DIR}/key.txt
    cat ${DIR}/key.txt | sed -n '3p' > ${DIR}/test.txt
    cat ${DIR}/test.txt | grep -i good > ${DIR}/good.txt
    cat ${DIR}/test.txt | grep -i gentoo > ${DIR}/gentoo.txt
    if [[ -s ${DIR}/good.txt && -s ${DIR}/gentoo.txt ]]; then
      PASS='true'
      rm ${DIR}/good.txt ${DIR}/gentoo.txt ${DIR}/test.txt
    fi
  }
  testKeys
  if [ PASS == 'false' ]; then
    gpg --keyserver hkps.pool.sks-keyservers.net --recv-keys $(cat ${DIR}/key.txt | sed -n '2p' | sed -e 's/^..*key //')
    testKeys
  fi
  grep -A 1 -i sha512 $DIGEST | grep $(sha512sum $FILE | sed -e 's/ .*.$//') > ${DIR}/sha.txt
  if [[ -s ${DIR}/sha.txt && PASS == 'true' ]]; then
    echo 'verification passed'
  else
    echo 'verification failed'
  fi
  
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
  rm ${DIR}/$$-err ${DIR}/$$-out ${DIR}/key.txt ${DIR}/sha.txt
  rm -R ${DIR}
  exit 0
fi
exit 1
