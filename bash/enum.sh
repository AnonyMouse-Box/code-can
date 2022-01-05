#!/bin/bash

# enum.sh - script for enumerating services on target machine
# call sudo ./enum.sh <target.IP> [-<flags> <scripts>]

PROBE=1
WAIT=1
INITIAL=1
TCP=1
UDP=1
SCTP=1
SCRIPTS="vuln"
DEFAULT_FLAGS="--min-parallelism 100 --max-rtt-timeout 300ms --min-rtt-timeout 50ms --initial-rtt-timeout 250ms --max-retries 2 --host-timeout 5m --script-timeout 3m --max-scan-delay 5ms -Pn"
RATE="--min-rate 4500"

if [[ $# -gt 1 ]]; then
    FLAG_ARRAY=($(echo $2 | cut -c2- | sed -e 's/\([[:alnum:]]\)/\1\ /g' | rev | cut -c2- | rev))
fi

if [[ $# -gt 2 ]]; then
    SCRIPTS=$3
fi

if [[ ${#FLAG_ARRAY[@]} -gt 0 ]]; then
    for i in "${FLAG_ARRAY[@]}"; do
        case $i in
            [h]) echo "try sudo ./enum.sh <target.IP> [-<flags> <scripts>]"; echo "Target should be in IP (169.254.0.0) or CIDR (169.254.0.0/16) form"; echo "Flags should be in the form '-AbCde' immediately following the target with no spaces"; echo "if scripts are scripts are required but no flags, use '-' as a placeholder"; echo "Scripts should be passed as you would to nmap, the default is 'vuln'"; echo ""; echo "Flags:"; echo "h - help"; echo "v - version"; echo "p - disable ping"; echo "w - no wait"; echo "i - disable initial scan"; echo "t - disable TCP scan by default"; echo "u - disable UDP scan by default"; echo "s - disable SCTP scan by default"; echo "if initial scan picks up open TCP, UDP or SCTP ports it will initiate further scans of them."exit 0;;
            [v]) echo "enum.sh version 0.0.0 - A service enumerating script."; exit 0;;
            [p]) PROBE=0;;
            [w]) WAIT=0;;
            [i]) INITIAL=0;;
            [t]) TCP=0;;
            [u]) UDP=0;;
            [s]) SCTP=0;;
            *) echo "Unrecognised flag '${FLAG_ARRAY[i]}'."; exit 1;;
        esac
    done
fi

if [[ ${PROBE} -eq 1 ]]; then
    echo "Detecting connection to host..."
    ping -c 1 $1
    while [[ $? -eq 1 ]]; do
        ping -c 1 $1
    done
fi

if [[ ${WAIT} -eq 1 ]]; then
    echo "Waiting for machine to finish booting..."
   sleep 300
fi

DIR=$(mktemp -d)

cleanup () {
    rm ${DIR}/$$-ip ${DIR}/$$-tcp ${DIR}/$$-udp ${DIR}/$$-sctp
    rm -R ${DIR}
}

if [[ ${#DIR} == 19 && -d ${DIR} ]]; then
    touch ${DIR}/$$-ip ${DIR}/$$-tcp ${DIR}/$$-udp ${DIR}/$$-sctp

    if [[ ${INITIAL} -eq 1 ]]; then
        echo "Performing initial scan..."
        nmap --min-rate 500 ${DEFAULT_FLAGS} -sO -p- $1 | tee -a ${DIR}/$$-ip
        SERVICES=($(cat ${DIR}/$$-ip | tr -s ' ' | grep -e '^[0-9].*open \(tcp\|udp\|sctp\)' | sed -e 's/^.* \(tcp\|udp\|sctp\).*$/\1/' | tr '\n' ' ' | rev | cut -c2- | rev))
    fi

    if [[ " ${SERVICES[*]} " =~ " tcp " || ${TCP} -eq 1 ]]; then
        echo "Detecting TCP ports..."
        nmap ${RATE} ${DEFAULT_FLAGS} -sS -p- $1 | tee -a ${DIR}/$$-tcp
        TCP_PORTS=$(grep -e 'tcp' ${DIR}/$$-tcp | sed -e 's/^\([0-9]*\)\/.*$/\1/' | tr '\n' ',' | rev | cut -c2- | rev)
        if [[ -n ${TCP_PORTS} ]]; then
            echo "Performing in depth TCP scan..."
            nmap ${RATE} ${DEFAULT_FLAGS} -sS -sV -O -p ${TCP_PORTS} --script=${SCRIPTS} $1
        fi
    fi

    if [[ " ${SERVICES[*]} " =~ " udp " || ${UDP} -eq 1 ]]; then
        echo "Detecting UDP ports..."
        nmap ${RATE} ${DEFAULT_FLAGS} -sU -p- $1 | tee -a ${DIR}/$$-udp
        UDP_PORTS=$(grep -e 'udp' ${DIR}/$$-udp | sed -e 's/^\([0-9]*\)\/.*$/\1/' | tr '\n' ',' | rev | cut -c2- | rev)
        if [[ -n ${UDP_PORTS} ]]; then
            echo "Performing in depth UDP scan..."
            nmap ${RATE} ${DEFAULT_FLAGS} -sU -p ${UDP_PORTS} --script=${SCRIPTS} $1
        fi
    fi

    if [[ " ${SERVICES[*]} " =~ " sctp " || ${SCTP} -eq 1 ]]; then
        echo "Detecting SCTP ports..."
        nmap ${RATE} ${DEFAULT_FLAGS} -sY -p- $1 | tee -a ${DIR}/$$-sctp
        SCTP_PORTS=$(grep -e 'sctp' ${DIR}/$$-sctp | sed -e 's/^\([0-9]*\)\/.*$/\1/' | tr '\n' ',' | rev | cut -c2- | rev)
        if [[ -n ${SCTP_PORTS} ]]; then
            echo "Performing in depth SCTP scan..."
            nmap ${RATE} ${DEFAULT_FLAGS} -sY -p ${SCTP_PORTS} --script=${SCRIPTS} $1
        fi
    fi

    cleanup
    exit 0
else
    echo "error making temporary file"
    cleanup
    exit 1
fi
