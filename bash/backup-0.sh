#!/bin/bash

function timestamp() {
  while IFS= read -r line; do
    echo [$(date +"%F %T.%N")] $line
  done
}

function fileType() {
  if [ -d "$1" ]; then
    TYPE="directory"
  else
    if [ -e "$1" ]; then
      TYPE="file"
    else
      TYPE="none"
    fi
 fi
 # add in detection for links
}

# redirect the stdout/stderr to screen AND log file
LOG="/var/log/usr/backup.log"
DIR=$(mktemp -d)
if [ ${#DIR} == 19 ]; then
  mkfifo ${DIR}/$$-err ${DIR}/$$-out
  # to merge stdout/stderr to log file AND screen
  ( exec tee -a ${LOG} < ${DIR}/$$-out ) &
  ( exec tee -a ${LOG} < ${DIR}/$$-err >&2 ) &
  # redirect stdout/stderr
  exec 1> >( timestamp ${DIR}/$$-out > ${DIR}/$$-out )
  exec 2> >( timestamp ${DIR}/$$-err > ${DIR}/$$-err )
  
  START=$(date +%s)
  echo ">>>START OF OUTPUT<<<"
  
  # backup-0.sh [backup source] [user]    [remote IP] [destination folder]
  # defaults    [/home]         [current] [127.0.0.1] [/mnt/backup]
  
  ERR=0
  ARG="$#"
  SRC="$1"
  USR="$2"
  HST="$3"
  DST="$4"
  
  for a in {1..5}; do
    case "$ARG" in
      "0")
        SRC="/home"
      ;;
      "1")
        USR="$USER"
      ;;
      "2")
        HST="127.0.0.1"
      ;;
      "3")
        DST="/mnt/backup"
      ;;
      "4")
      ;;
      *)
        echo "invalid number of arguments"
        exit 1
      ;;
    esac
    if [ "$ARG" != "4" ];
      then
        let "ARG += 1"
    fi
  done
    
  for error in {1..3}; do
    
    fileType $SRC
    echo `source is $TYPE`
    
    case "$TYPE" in
      "file")
        # add SRC to list of files to be backed up and jump to backup
      ;;
      "directory")
        # begin recursive iterations into the folder
      ;;
      "link")
        # find source of link and run file or directory test
      ;;
      "none"|*)
        let "ERR += 1"
        ERR1="000"
        continue
      ;;
    esac
  
    # /check source exists
      # /error out if not
    # catalogue all file and folders within source recursively
      # store the list in a temporary file that can be referenced later
    # check last updated time of every file in the list
      # if not updated since last run time add to new temporary exclusion file to be referenced later
    
        # use find and exec to reference every file or folder in a location, ls -al may also be useful
        # investigate grep and sed as they may be useful in pipe strings
        # from source folder
        # ls -Al | grep -e "^-" will list all ordinary files in a folder in long format
        # ls -ARl | grep -e "^\." will list recursively all directories in the folder in the format ./path/to/folder
        
        # for item in source
        # date -r [file] -u = Thu Aug 31 00:36:28 UTC 2017
        # if date hasn't changed check the checksum
        # check last modified date of each directory and file recursively
        # if not changed since last time this backup type was run add it to temporary exclude list
        # if has changed and a directory add to list of folders to recurse into and repeat process for each of them
        # done
        
        # once recursion is completed run tar to make an archive using the exclude list
        # compress archive with bzip2
        # check integrity
        # rename and rsync to server
        # daily weekly and monthly need now be separated out as archive will be different for each
        # on a monthly basis gather up all the old log files archive, compress, integrity check and stick them in an archive folder, finally clear backup folder
        # once the above is complete, add in function to copy the temporary log to log folder and repoint any followup logs
        # complete the building of an effective error logging system
        # be sure to ensure on the remote server when clearing out old monthly backups that their changes are applied to a base backup file
  
  done
  
  if [ $ERR -gt 2 ]; then
    echo "errored out too many times..."
    # add in case statement for different errors
    echo "unhandled exception"
    exit 1
  fi
  
  echo ">>>END OF OUTPUT<<<"
  END=$(date +%s)
  
  # calculate time taken
  SECONDS=$(echo "$END - $START" | bc)
  if [ $SECONDS > 3600 ]; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "completed in $hours hour(s), $minutes minute(s) and $seconds second(s)" 
  elif [ $SECONDS > 60 ]; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "completed in $minutes minute(s) and $seconds second(s)"
  else
    echo "completed in $SECONDS seconds"
  fi
  
  # remove temporary directory
  rm ${DIR}/$$-err ${DIR}/$$-out
  rm -R ${DIR}
  exit 0
fi
echo "error establishing temporary filesystem, exiting"
exit 1