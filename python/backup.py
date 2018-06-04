#!/usr/bin/env python3
# backup.sh converted into python
# backup.sh Files User Remote Folder Log
import subprocess
import argparse
parser.add_argument('Source', metavar='Files', nargs='1', default='/home', help='the file or folder to be backed up')
parser.add_argument('User', metavar='User', nargs='1', default='current', help='the user to perform the action')
parser.add_argument('Host', metavar='Remote', nargs='1', default='localhost', help='the remote server to send the files to')
parser.add_argument('Destination', metavar='Folder', nargs='1', default='/mnt/backup', help='the remote folder to store the backup')
parser.add_argument('Folder', metavar='Log', nargs='1', default='/home/user/log', help='the location to put the log file')
subprocess.run(['tar', '--exclude="Folder"', '-cpvf', '"Backup".tar', '"Source"', '&>>', '"$Temporary"'], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
subprocess.run(['bzip2', '-zvk', '"Backup".tar', '&>>', '"$Temporary"'], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
subprocess.run(['bzip2', '-vt', '"Backup".tar.bz2', '&>>', '"$Temporary"'], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
subprocess.run(['rsync', '-htvpEogSm', '"Backup"', '"User"@"Host":"Destination"', '&>>', '"$Temporary"'], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
