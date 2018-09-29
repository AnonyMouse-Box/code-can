#!/bin/bash

# redirect the stdout/stderr to screen AND log file
LOG="/var/log/usr/file.log"
DIR=$(mktemp -d)
if [ ${#DIR} == 14 ]; then
  mkfifo ${DIR}/$$-err ${DIR}/$$-out
  # to merge stdout/stderr to log file AND screen
  ( exec tee -a ${LOG} <${DIR}/$$-out ) &
  ( exec tee -a ${LOG} <${DIR}/$$-err >&2 ) &
  # redirect stdout/stderr
  exec 1>${DIR}/$$-out
  exec 2>${DIR}/$$-err
  
  # remove temporary directory
  rm -R ${DIR}
  exit 0
fi
exit 1