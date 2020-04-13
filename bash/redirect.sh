#!/usr/bin/env bash
# if run via cron pipe STDOUT to /dev/null to have it only email when it errors
# any commands for which you don't care about the errors simply redirect STDERR to STDOUT using 2>&1
# for anything you would wish to receive a high priority email for use ERROR=${True}

# make timestamp
function timestamp() {
  while IFS= read -r line; do
    echo [$(date +"%F %T.%N")] $line
  done
}

# define boolean logic
True=1
False=0

# make temporary directory
DIR=$(mktemp -d)

# set key variables
ERROR=${False}
LOG="LOG FILE"
EMAIL="EMAIL ADDRESS"
SUBJECT="EMAIL SUBJECT"
MESSAGE=`mktemp ${DIR}/email.XXXXXX`

# set email headers
echo "To: ${EMAIL}" >> ${MESSAGE}
echo "From: `hostname`@EMAIL DOMAIN" >> ${MESSAGE}
echo "Subject: ${SUBJECT}" >> ${MESSAGE}

# redirect the stdout/stderr to screen AND log file
if [ ${#DIR} == 19 ]; then
  mkfifo ${DIR}/$$-err ${DIR}/$$-out
  
  # to merge stdout/stderr to log file AND screen
  ( exec tee -a ${LOG} < ${DIR}/$$-out ) &
  ( exec tee -a ${LOG} < ${DIR}/$$-err >&2 ) &
  
  # redirect stdout/stderr
  exec 1> >( timestamp ${DIR}/$$-out > ${DIR}/$$-out )
  exec 2> >( timestamp ${DIR}/$$-err > ${DIR}/$$-err )

  START=$(date +%s)
  # echo ">>>START OF SCRIPT<<<"
  
  ### INSERT SCRIPT HERE ###
  
  # echo ">>>END OF OUTPUT<<<"
  END = $(date +%s)
  
  # calculate time taken
  SECONDS = $(bc <<< "${END} - ${START}")
  let "hours = SECONDS/3600"
  let "minutes = (SECONDS%3600)/60"
  let "seconds = (SECONDS%3600)%60"
  
  # prepare statement
  if [ ${hours} -lt 1 ] && [ ${minutes} -lt 1 ] && [ ${seconds} -lt 1 ]; then
    LESS = ${True}
  else
    LESS = ${False}
    if [ ${hours} -gt 0 ] && [ ${minutes} -gt 0 ] && [ ${seconds} -gt 0 ]; then
      ANDONE = ${False}
      COMMA = ${True}
    elif [ ${hours} -gt 0] && [ ${minutes} -gt 0 ]; then
      ANDONE = ${True}
	  COMMA = ${False}
    else
      ANDONE = ${False}
	  COMMA = ${False}
    fi
    if [[ ${hours} -gt 0 ] && [ ${seconds} -gt 0 ]] || [[ ${minutes} -gt 0 ] && [ ${seconds} -gt 0 ]]; then
      ANDTWO = ${True}
    else
      ANDTWO = ${False}
    fi
    if [ ${hours} -gt 0 ]; then
      HOUR = ${True}
    else
      HOUR = ${False}
    fi
    if [ ${minutes} -gt 0 ]; then
      MINUTE = ${True}
    else
      MINUTE = ${False}
    fi
    if [ ${seconds} -gt 0 ]; then
      SECOND = ${True}
    else
      SECOND = ${False}
    fi
    if [ ${hours} -gt 1 ]; then
      SONE = ${True}
    else
      SONE = ${False}
    fi
    if [ ${minutes} -gt 1 ]; then
      STWO = ${True}
    else
      STWO = ${False}
    fi
    if [ ${seconds} -gt 1 ]; then
      STHREE = ${True}
    else
      STHREE = ${False}
    fi
  fi
  
  # construct sentence
  sentence = "Completed in"
  if [ ${HOUR} == ${True} ]; then
    let 'sentence = ${sentence} + " ${hours} hour"'
  fi
  if [ ${SONE} == ${True} ]; then
    let 'sentence = ${sentence} + "s"'
  fi
  if [ ${COMMA} == ${True} ]; then
    let 'sentence = ${sentence} + ","'
  fi
  if [ ${ANDONE} == ${True} ]; then
    let 'sentence = ${sentence} + " and"'
  fi
  if [ ${MINUTE} == ${True} ]; then
    let 'sentence = ${sentence} + " ${minutes} minute"'
  fi
  if [ ${STWO} == ${True} ]; then
    let 'sentence = ${sentence} + "s"'
  fi
  if [ ${ANDTWO} == ${True} ]; then
    let 'sentence = ${sentence} + " and"'
  fi
  if [ ${SECOND} == ${True} ]; then
    let 'sentence = ${sentence} + " ${seconds} second"'
  fi
  if [ ${STHREE} == ${True} ]; then
    let 'sentence = ${sentence} + "s"'
  fi
  if [ ${LESS} == ${True} ]; then
    let 'sentence = ${sentence} + " less than a second"'
  fi  
  let 'sentence = ${sentence} + "."'
  echo ${sentence}

  # if error set high priority
  if [ ${ERROR} == ${True} ]; then
    sed -i '4s;^;Importance: High\nX-Priority: 1\n;' ${MESSAGE}
  fi
  
  # send email
  /usr/sbin/sendmail -t < ${MESSAGE}
  
  # remove temporary directory
  rm ${DIR}/$$-err ${DIR}/$$-out
  rm -R ${DIR}
  
  exit 0
fi
exit 1
