#!env python
# backup.sh converted into python
# backup.sh Files User Remote Folder Log
import subprocess
import argparse
subprocess.run(["tar", "--exclude='$3'", "-cpvf", "'$2'", "'$1'", "&>>", "'$TMP'"], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
subprocess.run(["bzip2", "-zvk", "'$1.tar'", "&>>", "'$TMP'"], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
subprocess.run(["bzip2", "-vt", "'$1'", "&>>", "'$TMP'"], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
subprocess.run(["rsync", "-htvpEogSm", "'$1'", "'$USER@$HST:$DST'", "&>>", "'$TMP'"], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
