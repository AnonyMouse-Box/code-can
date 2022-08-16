#!/usr/bin/env bash
: <<'END_DESCRIPTION'
enumeration.sh

A script for performing automated enumeration of systems.

Script requires superuser privileges and u+x permissions, it should be owned by user. Adjust LOG variable to set external log file location. To send an automated email containing logs, adjust appropriate key variables and set SEND to ${True}.

Dependencies:
bash
hostname
whoami
echo
sed
grep
awk
exec
sudo
sleep
wait
mktemp
mkfifo
tee
bc
sendmail (for email)
arp-scan
nmap
enum4linux
smbclient
rpcclient
ssh

END_DESCRIPTION

# Run script as superuser
if [ "$UID" -ne 0 ]; then
    exec sudo "$0" "$@"
    exit $?
fi

# Define boolean logic
True=1
False=0

# Key variables
LOG="LOG_FILE"
EMAIL="EMAIL_ADDRESS"
SUBJECT="EMAIL_SUBJECT"
NAME=`hostname`
DOMAIN="EMAIL_DOMAIN"
SEND=${False}
ERROR=${False}
additional=()

# Colours
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'

# Make timestamp
function timestamp() {
    while IFS= read -r line; do
        echo [$(date +"%F %T.%N")] $line
    done
}

# Make temporary directory
DIR=$(mktemp -d)

# Check temporary directory is valid and make filestreams
if [ ${#DIR} == 19 ]; then
    mkfifo ${DIR}/$$-out ${DIR}/$$-err

    # Handle no log file
    if [[ ${LOG} == "LOG_FILE" ]]; then
        LOG=${DIR}/$$-log
    fi

    # Merge stdout/stderr to screen and dump to log
    ( exec tee -a ${LOG} ${MESSAGE} < ${DIR}/$$-out ) &
    ( exec tee -a ${LOG} ${MESSAGE} < ${DIR}/$$-err >&2 ) &

    # Redirect stdout/stderr to temporary filestreams with a timestamp
    exec 1> >( timestamp ${DIR}/$$-out > ${DIR}/$$-out )
    exec 2> >( timestamp ${DIR}/$$-err > ${DIR}/$$-err )

    # Notify user
    echo -e Running as ${RED}`whoami`${NC}!

    # Set email headers
    MESSAGE=`mktemp ${DIR}/$$-email.XXXXXX`
    echo "To: ${EMAIL}" >> ${MESSAGE}
    echo "From: ${NAME}@${DOMAIN}" >> ${MESSAGE}
    echo "Subject: ${SUBJECT}" >> ${MESSAGE}

    # Remove temporary files
    cleanup () {
        for file in ${DIR}/$$-out ${DIR}/$$-err ${DIR}/$$-log ${MESSAGE} ${additional[@]}; do
            if [[ -f file ]]; then
                rm file
            fi
        done
        rm -R ${DIR}
    }

    START=$(date +%s)
    # >>>START OF SCRIPT<<<

    TARGETS=()
    RATE="--min-rate 4500"
    DEFAULT_FLAGS="--min-parallelism 100 --max-rtt-timeout 1000ms --min-rtt-timeout 50ms --initial-rtt-timeout 250ms --max-retries 10 --host-timeout 30m --script-timeout 15m --max-scan-delay 5ms -Pn"
    SCRIPTS="vuln"

    arp_file=`mktemp ${DIR}/$$-arp.XXXXXX`
    probe_file=`mktemp ${DIR}/$$-probe.XXXXXX`
    tcp_file=`mktemp ${DIR}/$$-tcp.XXXXXX`
    udp_file=`mktemp ${DIR}/$$-udp.XXXXXX`
    sctp_file=`mktemp ${DIR}/$$-sctp.XXXXXX`
    additional=(${arp_file} ${probe_file} ${tcp_file} ${udp_file} ${sctp_file})

    # Check for arguments
    if [[ $# -gt 0 ]]; then

        # Parse flags
        FLAG_ARRAY=($(echo "$*" | sed -e 's/\(.*\)/ \1/' -e 's/ [^- ][^ ]*//g' -e 's/-\([^ ]*\)/\1/g'))
        for flag in ${FLAG_ARRAY[@]}; do
            OPTIONS=()

            # Detect if minified or long form
            if [[ ! ${flag::1} == "-" ]]; then
                OPTIONS=($(echo ${flag} | sed -e 's/\(.\)/\1 /g' -e 's/\(.\) $/\1/'))
            else
                OPTIONS=($(echo ${flag#*-}))
            fi
            # Set options as requested
            for option in ${OPTIONS[@]}; do
                case ${option} in
                    h|help)
                        echo enumeration.sh help
                        echo -------------------
                        echo -e "Usage: ${GREEN}$0 [<target> <flags>]${NC}"
                        echo
                        echo "A script for performing automated enumeration of systems."
                        echo
                        echo "Script requires superuser privileges and u+x permissions, it should"
                        echo "be owned by user. Adjust LOG variable to set external log file"
                        echo "location. To send an automated email containing logs, adjust"
                        echo "appropriate key variables and set SEND to True."
                        echo
                        echo "enumeration.sh can take multiple targets of three different forms."
                        echo "It can also take no targets in which case it will attempt to"
                        echo "enumerate any devices it can locate via ARP."
                        echo
                        echo target
                        echo ------
                        echo "IP - 127.0.0.1"
                        echo "CIDR - 127.0.0.1/24"
                        echo "Domain - subdomain.example.com"
                        echo
                        echo flags
                        echo -----
                        echo "-h, --help - helpful information"
                        cleanup
                        sleep 1
                        exit 0 ;;
                    *)
                        echo -e Unrecognized option: ${RED}${option}${NC}
                        cleanup
                        sleep 1
                        exit 1 ;;
                esac
            done
        done

        # Remove flags
        ARG_ARRAY=($(echo "$*" | sed -e 's/-[^ ]*//g'))

        # Process arguments
        for arg in ${ARG_ARRAY[@]}; do
            IP=""

            # Check for IPs and Subnets
            if echo ${arg} | grep --quiet -E '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(/[0-9]{1,2})?$'; then

                # Check IP is valid
                FAIL=${False}
                OCTETS=($(echo ${arg} | sed -e 's#/[0-9]*##' | tr '.' ' '))
                for number in ${OCTETS[@]}; do
                    if [[ ${number} -gt 255 ]]; then
                        FAIL=${True}
                    fi
                done

                # Check Mask is valid
                if echo ${arg} | grep --quiet -E '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}$'; then
                    MASK=$(echo ${arg} | sed -e 's#.*/##')
                    if [[ ${MASK} -gt 32 ]]; then
                        FAIL=${True}
                    fi
                fi

                # Mark as target
                if [[ ${FAIL} == ${False} ]]; then
                    IP=${arg}
                    TARGETS+=(${arg})
                fi

            # Check for Domains
            elif echo ${arg} | grep --quiet "^[a-zA-Z0-9.-]*\.[a-zA-Z0-9-]*$"; then
                IP=${arg}
                TARGETS+=(${arg})
            fi

            # Scan valid targets otherwise skip
            if [[ ${IP} == "" ]]; then
                echo -e "\nInvalid target ${RED}${arg}${NC}"
                echo Skipping ...
                continue
            else
                echo -e "\nProcessing ${GREEN}${arg}${NC} ..."
                echo -e ${BLUE}[${arg}] ARP-Scan${NC}
                arp-scan ${IP} | tee -a ${arp_file}
            fi
        done
    else
        # Scan for targets
        echo -e "\n${RED}No targets${NC} provided"
        echo Scanning interfaces ...
        echo -e ${BLUE}ARP-Scan${NC}
        arp-scan -l | tee -a ${arp_file}
        TARGETS+=($(grep -E '^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}' ${arp_file} | awk -F ' ' '{print $1}'))
    fi

    for target in ${TARGETS[@]}; do
        echo -e "\n${BLUE}[${target}] Probe Scan${NC}"
        nmap --min-rate 500 ${DEFAULT_FLAGS} -sO -p- ${target} | tee -a ${probe_file}

        echo -e "\n${BLUE}[${target}] TCP Port Scan${NC}"
        nmap ${RATE} ${DEFAULT_FLAGS} -sS -p- ${target} | tee -a ${tcp_file}
        TCP_PORTS=$(grep '^[0-9]' ${tcp_file} | grep -i 'open' | awk -F ' ' '{print $1}' | sed -e 's#/tcp##' | tr '\n' ',' | sed -e 's/,$//')

        if [[ -n ${TCP_PORTS} ]]; then
            echo -e "\n${BLUE}[${target}] TCP Deep Scan${NC}"
            echo -e "Be patient, deep scan may take ${RED}up to 30 minutes${NC} to run and will ${GREEN}cancel automatically${NC}."
            nmap ${RATE} ${DEFAULT_FLAGS} -sS -sV -O -p ${TCP_PORTS} --script=${SCRIPTS} ${target} | tee ${tcp_file}
        fi

        echo -e "\n${BLUE}[${target}] UDP Port Scan${NC}"
        nmap ${RATE} ${DEFAULT_FLAGS} -sU -p- ${target} | tee -a ${udp_file}
        UDP_PORTS=$(grep '^[0-9]' ${udp_file} | grep -i 'open' | awk -F ' ' '{print $1}' | sed -e 's#/udp##' | tr '\n' ',' | sed -e 's/,$//')

        if [[ -n ${UDP_PORTS} ]]; then
            echo -e "\n${BLUE}[${target}] UDP Deep Scan${NC}"
            echo -e "Be patient, deep scan may take ${RED}up to 30 minutes${NC} to run and will ${GREEN}cancel automatically${NC}."
            nmap ${RATE} ${DEFAULT_FLAGS} -sU -sV -p ${UDP_PORTS} --script=${SCRIPTS} ${target}
        fi

        echo -e "\n${BLUE}[${target}] SCTP Port Scan${NC}"
        nmap ${RATE} ${DEFAULT_FLAGS} -sY -p- ${target} | tee -a ${sctp_file}
        SCTP_PORTS=$(grep '^[0-9]' ${sctp_file} | grep -i 'open' | awk -F ' ' '{print $1}' | sed -e 's#/sctp##' | tr '\n' ',' | sed -e 's/,$//')

        if [[ -n ${SCTP_PORTS} ]]; then
            echo -e "\n${BLUE}[${target}] SCTP Deep Scan${NC}"
            echo -e "Be patient, deep scan may take ${RED}up to 30 minutes${NC} to run and will ${GREEN}cancel automatically${NC}."
            nmap ${RATE} ${DEFAULT_FLAGS} -sY -sV -p ${SCTP_PORTS} --script=${SCRIPTS} ${target}
        fi

        HTTP_PORTS=($(grep '^[0-9]' ${tcp_file} | grep -i 'http ' | awk -F ' ' '{print $1}' | sed -e 's#/tcp##'))
        if [[ ${#HTTP_PORTS[@]} -ne 0 ]]; then
            for http_port in ${HTTP_PORTS[@]}; do
                echo -e "\n${BLUE}[${target}:${http_port}] HTTP Scan${NC}"
                nikto -h http://${target}:${http_port}
            done
        fi

        SSH_PORTS=($(grep '^[0-9]' ${tcp_file} | grep -i 'ssh ' | awk -F ' ' '{print $1}' | sed -e 's#/tcp##'))
        if [[ ${#SSH_PORTS[@]} -ne 0 ]]; then
            for ssh_port in ${SSH_PORTS[@]}; do
                echo -e "\n${BLUE}[${target}:${ssh_port}] SSH Probe${NC}"
                ssh -f -N -oStrictHostKeyChecking=no anonymous@${target} -p ${ssh_port} &
                PIDSSH=$!
                ( sleep 5; echo "Done."; kill ${PIDSSH} ) &
                PIDSLEEP=$!
                wait ${PIDSSH}
                if ps -p ${PIDSLEEP} > /dev/null; then
                    kill ${PIDSLEEP} && echo "Session ended before timeout."
                    wait
                fi
            done
        fi

        SMB_PORTS=($(grep -i '_smb' ${tcp_file}))
        RPC_PORTS=($(grep -i '_rpc' ${tcp_file}))
        if [[ ${#SMB_PORTS[@]} -ne 0 || ${#RPC_PORTS[@]} -ne 0 ]]; then
            echo -e "\n${BLUE}[${target}] SMB and RPC Scan${NC}"
            enum4linux -a ${target}
        fi
    done

    # >>>END OF SCRIPT<<<
    END=$(date +%s)

    # Calculate time taken
    SECONDS=$(bc <<< "${END} - ${START}")
    ((hours = ${SECONDS} / 3600))
    ((minutes = (${SECONDS} % 3600) / 60))
    ((seconds = (${SECONDS} % 3600) % 60))

    # Set variables
    LESS=${False}
    ANDONE=${False}
    ANDTWO=${False}
    COMMA=${False}
    HOUR=${False}
    MINUTE=${False}
    SECOND=${False}
    SONE=${False}
    STWO=${False}
    STHREE=${False}

    # Prepare statement
    if [ ${hours} -lt 1 ] && [ ${minutes} -lt 1 ] && [ ${seconds} -lt 1 ]; then
        LESS=${True}
    else
        if [ ${hours} -gt 0 ] && [ ${minutes} -gt 0 ] && [ ${seconds} -gt 0 ]; then
            COMMA=${True}
        elif [ ${hours} -gt 0 ] && [ ${minutes} -gt 0 ]; then
            ANDONE=${True}
        fi
        if [[ ( ${hours} -gt 0 && ${seconds} -gt 0 ) || ( ${minutes} -gt 0 && ${seconds} -gt 0 ) ]]; then
            ANDTWO=${True}
        fi
        if [ ${hours} -gt 0 ]; then
            HOUR=${True}
        fi
        if [ ${minutes} -gt 0 ]; then
            MINUTE=${True}
        fi
        if [ ${seconds} -gt 0 ]; then
            SECOND=${True}
        fi
        if [ ${hours} -gt 1 ]; then
            SONE=${True}
        fi
        if [ ${minutes} -gt 1 ]; then
            STWO=${True}
        fi
        if [ ${seconds} -gt 1 ]; then
            STHREE=${True}
        fi
    fi

    # Generate sentence
    sentence="Completed in"
    if [ ${HOUR} == ${True} ]; then
        sentence+=" ${hours} hour"
    fi
    if [ ${SONE} == ${True} ]; then
        sentence+="s"
    fi
    if [ ${COMMA} == ${True} ]; then
        sentence+=","
    fi
    if [ ${ANDONE} == ${True} ]; then
        sentence+=" and"
    fi
    if [ ${MINUTE} == ${True} ]; then
        sentence+=" ${minutes} minute"
    fi
    if [ ${STWO} == ${True} ]; then
        sentence+="s"
    fi
    if [ ${ANDTWO} == ${True} ]; then
        sentence+=" and"
    fi
    if [ ${SECOND} == ${True} ]; then
        sentence+=" ${seconds} second"
    fi
    if [ ${STHREE} == ${True} ]; then
        sentence+="s"
    fi
    if [ ${LESS} == ${True} ]; then
        sentence+=" less than a second"
    fi
    sentence+="."
    echo -e "${PURPLE}${sentence}${NC}"

    # Set high priority on error
    if [ ${ERROR} == ${True} ]; then
        sed -i '4s;^;Importance: High\nX-Priority: 1\n;' ${MESSAGE}
    fi

    # Send email
    if [ ${SEND} == ${True} ]; then
        /usr/bin/sendmail -t < ${MESSAGE}
    fi

    cleanup
    sleep 1
    exit 0
else
    echo -e "${RED}Error making temporary file!${NC}"
    cleanup
    sleep 1
    exit 1
fi
