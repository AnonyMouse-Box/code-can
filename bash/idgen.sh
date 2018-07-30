#!/bin/bash
ID="/tmp/id.txt"
LS="idlist.txt"
for i in {1..3}; do
 tr -dc A-Za-z0-9 </dev/urandom | head -c 64 | sed -r "s/(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})/\1-\2-\3-\4 : \5-\6-\7-\8/" > $ID
 if [ -z "$( cat $ID | grep $LS )" ]; then
  cat $ID >> $LS ; echo >> $LS ; cat "$ID" ; echo ; rm $ID
  exit 0
 fi
done
rm $ID ; echo "duplication error: check config or try again./n"
exit 1