#!/bin/bash
 redirect the stdout/stderr to screen AND log file
LOG="/var/log/usr/update.log"
DIR=$(mktemp -d)
if [ ${#DIR} == 19 ]; then
  mkfifo ${DIR}/$$-err ${DIR}/$$-out
  # to merge stdout/stderr to log file AND screen
  ( exec tee -a ${LOG} <${DIR}/$$-out ) &
  ( exec tee -a ${LOG} <${DIR}/$$-err >&2 ) &
  # redirect stdout/stderr
  exec 1>${DIR}/$$-out
  exec 2>${DIR}/$$-err
  
  # check network access, ping gateway
  ping -c 5 '192.168.36.1'
  VAR=0
  while [ $? != 0 ]; do
    sleep 300
    ping -c 5 '192.168.36.1'
    ((VAR++))
    if [ $VAR == 12 ]; then
      exit 1
    fi
  done
  # ping google to check internet access and dns
  ping -c 5 'www.google.com'
  NUM=0
  while [ $? != 0 ]; do
    sleep 300
    ping -c 5 'www.google.com'
    ((NUM++))
    if [ $VAR == 12 ]; then
      exit 1
    fi
  done
  
  # update root DNS server list
  wget -O ${DIR}/root.hints "https://www.internic.net/domain/named.root"
  if [ ! diff ${DIR}/root.hints /var/lib/unbound/root.hints ]; then
    cp ${DIR}/root.hints /var/lib/unbound/root.hints
  fi
  rm ${DIR}/root.hints
  
  # update pihole
  pihole -g
  pihole -up
  
  # update repositories, software and clear orphaned packages
  apt-get update
  apt-get upgrade -y
  apt-get autoclean -y
  apt-get autoremove -y
  deborphan | xargs -0 apt-get -y remove --purge
  
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