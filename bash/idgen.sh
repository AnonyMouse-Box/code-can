#!/bin/bash
tr -dc A-Za-z0-9 < /dev/urandom | head -c 64 | sed -r "s/(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})/\1-\2-\3-\4 : \5-\6-\7-\8/" > id.txt
exit 0