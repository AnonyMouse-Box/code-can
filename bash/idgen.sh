#!/bin/bash
tr -dc A-Za-z0-9 < /dev/urandom | head -c 16 | sed -r "s/(....)(....)(....)(....)/\1-\2-\3-\4/" > id.txt
exit 0