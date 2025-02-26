#!/bin/bash
#Author: Ellery Weber
#Modified by Zach Johnson

# Usage function
usage() {
    echo "Usage: $0 hostname.domain.com [-D <local_socks_port>] [-R <remote_port>] [-N <nessus_port>]"
    exit 1
}

# Default ports
D_PORT=9090
R_PORT=9051
N_PORT=8834

# Check if the hostname argument is provided
if [ -z "$1" ]; then
    usage
fi

HOST=$1
shift

# Parse optional arguments
while getopts "D:R:N:" opt; do
    case ${opt} in
        D) D_PORT=$OPTARG;;
        R) R_PORT=$OPTARG;;
        N) N_PORT=$OPTARG;;
        *) usage;;
    esac
done

# Function to check SSH command success
run_ssh_command() {
    "$@"
    if [ $? -ne 0 ]; then
        echo "Error: Command failed - $@"
        exit 1
    fi
}

# Run the SSH commands with error checking
run_ssh_command ssh -fND $D_PORT root@$HOST
run_ssh_command ssh -fNR $D_PORT:localhost:$D_PORT root@$HOST
run_ssh_command ssh -fNL $N_PORT:127.0.0.1:$N_PORT root@$HOST
run_ssh_command ssh -fNR 127.0.0.1:$R_PORT root@$HOST

echo "SSH commands executed successfully on $HOST with -D $D_PORT, -N $N_PORT, and -R $R_PORT"