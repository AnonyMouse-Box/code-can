#!/bin/bash

function timestamp() {
  while IFS= read -r line; do
    echo '[$(date +"%F %T.%N")] $line'
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
  exec 1> >(timestamp ${DIR}/$$-out)
  exec 2> >(timestamp ${DIR}/$$-err)
  
  # remove temporary directory
  rm ${DIR}/$$-err ${DIR}/$$-out
  rm -R ${DIR}
  exit 0
fi
exit 1