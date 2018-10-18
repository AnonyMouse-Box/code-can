#!/bin/bash

function timestamp() {
  while IFS= read -r line; do
    echo [$(date +"%F %T.%N")] $line
  done
}
# redirect the stdout/stderr to screen AND log file
LOG="~/burn.log"
DIR=$(mktemp -d)
if [ ${#DIR} == 19 ]; then
  mkfifo ${DIR}/$$-err ${DIR}/$$-out
  # to merge stdout/stderr to log file AND screen
  ( exec tee -a ${LOG} < ${DIR}/$$-out ) &
  ( exec tee -a ${LOG} < ${DIR}/$$-err >&2 ) &
  # redirect stdout/stderr
  exec 1> >( timestamp ${DIR}/$$-out > ${DIR}/$$-out )
  exec 2> >( timestamp ${DIR}/$$-err > ${DIR}/$$-err )
  
  sensors >> ~/sensors.log
  
  stress-ng --cpu 8 -v -t 70d --aggressive --metrics-brief --perf
  
  sensors >> ~/sensors.log
  
  # remove temporary directory
  rm ${DIR}/$$-err ${DIR}/$$-out
  rm -R ${DIR}
  exit 0
fi
exit 1