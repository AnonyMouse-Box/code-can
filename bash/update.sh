#!/bin/bash

function timestamp() {
  while IFS= read -r line; do
    echo [$(date +'%F %T.%N')] $line
  done
}
# redirect the stdout/stderr to screen AND log file
LOG="/var/log/usr/update.log"
DIR=$(mktemp -d)
if [ ${#DIR} == 19 ]; then
  mkfifo ${DIR}/$$-err ${DIR}/$$-out
  # to merge stdout/stderr to log file AND screen
  ( exec tee -a ${LOG} < ${DIR}/$$-out ) &
  ( exec tee -a ${LOG} < ${DIR}/$$-err >&2 ) &
  # redirect stdout/stderr
  exec 1> >( timestamp ${DIR}/$$-out > ${DIR}/$$-out )
  exec 2> >( timestamp ${DIR}/$$-err > ${DIR}/$$-err )
  
  # check network access, ping gateway
  VAR=0
  ping -c 5 '192.168.36.1'
  while [ $? != 0 ]; do
    ((VAR++))
    if [ $VAR == 12 ]; then
      exit 1
    fi
    sleep 300
    ping -c 5 '192.168.36.1'
  done
  # ping google to check internet access and dns
  NUM=0
  ping -c 5 'www.google.com'
  while [ $? != 0 ]; do
    ((NUM++))
    if [ $VAR == 12 ]; then
      exit 1
    fi
    sleep 300
    ping -c 5 'www.google.com'
  done
  
  # update root DNS server list
  wget -O ${DIR}/root.hints "https://www.internic.net/domain/named.root"
  FILE1=$(openssl dgst ${DIR}/root.hints)
  FILE2=$(openssl dgst /var/lib/unbound/root.hints)
  if [ ${FILE1:(-64)} != ${FILE2:(-64)} ]; then
    cp ${DIR}/root.hints /var/lib/unbound/root.hints
  fi
  rm ${DIR}/root.hints
  
  # update pihole
  pihole -g
  pihole -up
  
  # update repositories, software and clear orphaned packages
  apt-get update
  apt-get upgrade -y
  apt-get autoclean
  apt-get autoremove -y
  deborphan | xargs apt-get -y remove --purge
  
  # reboot if required
  if [ -f /var/run/reboot-required ]; then
    reboot
  fi
  
  # remove temporary directory
  rm ${DIR}/$$-err ${DIR}/$$-out
  rm -R ${DIR}
  exit 0
fi
exit 1