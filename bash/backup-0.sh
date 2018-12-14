#!/bin/bash

function timestamp() {
  while IFS= read -r line; do
    echo [$(date +"%F %T.%N")] $line
  done
}
# redirect the stdout/stderr to screen AND log file
LOG="/var/log/usr/file.log"
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

  # backup-0.sh [backup source] [user] [remote IP] [destination folder]
  # defaults    [/home] [current] [127.0.0.1] [/mnt/backup]
  
//  function DirExist(){
    if [ ! -d '$1' ];
      then
        return 1
      else
        return 0
    fi
  }
  
  function CreateDir(){
    mkdir -p '$1'
    echo
  }
  
  function IsAlive(){
    ping -c 5 '$1'
    echo
    for i in {1..12};
      then
        if [ '$?' != '0' ];
          then
            sleep 300
            ping -c 5 '$1'
            echo
          else
            return 0
        fi
    done
    return 1
  }
  
  ERR='false'
  
  DirExist '/tmp'
  if [ '$?' != '0' ];
    then
      CreateDir '/tmp'
  fi
  
  if [ '$?' != '0' ];
    then
      ERR='2'
  fi
  
  
  echo 'initializing'
  echo
  
  ARG='$#'
  NOW='$(date +%c)'
  USR='$2'
  HST='$3'
  SRC='$1'
  DST='$4'
  
  for a in {1..5};
    do
      case '$ARG' in
        '0')
          SRC='/home'
        ;;
        '1')
          USR='$USER'
        ;;
        '2')
          HST='127.0.0.1'
        ;;
        '3')
          DST='/mnt/backup'
        ;;
        '4')
        ;;
        *)
          ERR='0'
          break
        ;;
      esac
      if [ '$ARG' != '4' ];
        then
          let 'ARG += 1'
      fi
  done
  
  if [ '$ERR' != 'false' ];
    then
      echo '$NOW'
      echo 'startup error: exiting script'
      echo
      echo
      exit 1
  fi
  
  LOG='$FOL/backup-$(date +%d).log'
  DIR='/tmp/directory.txt'
  BAK='/tmp/backup'
  MBK='/tmp/backup-$(date +%b)'
  WBK='/tmp/backup-$(date +%d)'
  DBK='/tmp/backup-$(date +%a)'
  LIN='1'
  daily='0'
  weekly='0'
  monthly='0'
  tar='0'
  compress='0'
  copy='0'
  integrity='0'
  
  echo 'backup process begun $NOW:'
  echo
  
  for i in {1..3};
    then
      IsAlive '$HST'
      if [ '$?' != '0' ];
        then
          ERR='1'
          echo '$NOW'
          echo 'no response from $HST'
          echo
          continue
      fi
      
      ls -ARl $SRC | grep -e "^\." > $DIR
      sed -ne "$LIN p" -e "s:^\.:$SRC:" $DIR | ls -Al | grep -e "^-" | sed "s_^.* .* .* .* .* .* .* .* _$SRC/_" > $FIL
      
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
      
      echo 'backup complete $NOW.'
      echo
      echo
      exit 0
  done
  
  case $ERR in
    '0')
      echo 'syntax error, exiting'
      echo
      ;;
    '1')
      echo 'could not connect to remote server, exiting'
      echo
      ;;
    '2')
      echo 'could not create folder, exiting'
      echo
      ;;
    *)
      echo 'critical failure: undesignated error, exiting'
      echo
      echo
      exit 1
      ;;
  esac
  
  echo 'backup aborted $NOW.'
  echo
  echo
  exit 1//
  
  echo ">>>END OF OUTPUT<<<"
  END=$(date +%s)
  
  # calculate time taken
  SECONDS=$(echo "$END - $START" | bc)
  if [ $SECONDS > 3600 ]; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)" 
  elif [ $SECONDS > 60 ]; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $minutes minute(s) and $seconds second(s)"
  else
    echo "Completed in $SECONDS seconds"
  fi
  
  # remove temporary directory
  rm ${DIR}/$$-err ${DIR}/$$-out
  rm -R ${DIR}
  exit 0
fi
exit 1