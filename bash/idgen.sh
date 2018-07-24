#!/bin/bash
tr -dc A-Za-z0-9 < /dev/urandom | head -c 64 | sed -r "s/(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})/\1-\2-\3-\4 : \5-\6-\7-\8/" > id.txt
if [ -z "$(cat id.txt | grep idlist.txt)" ] ;
	then
    	cat id.txt >> idlist.txt
fi
exit 0