#!/bin/bash
#Author: Ellery Weber
#Modified by Zach Johnson

# Usage function
usage() {
    echo "Usage: $0 hostname.domain.com [-U <remote_user>] [-O <remote_outbound_via_local_socks_port>] [-I <local_into_remote_network_via_local_socks_port>] [-N <nessus_port>] [-R <remote_into_local_port>]"
    exit 1
}

# Default ports
O_PORT=9050
I_PORT=9999
N_PORT=8834
R_PORT=8000

# Default user
R_USER=root

# Check if the hostname argument is provided
if [ -z "$1" ]; then
    usage
fi

R_HOST=$1
shift

# Parse optional arguments
while getopts "O:I:N:R:U:" opt; do
    case ${opt} in
        O) O_PORT=$OPTARG;;
        I) I_PORT=$OPTARG;;
        N) N_PORT=$OPTARG;;
        R) R_PORT=$OPTARG;;
        U) R_USER=$OPTARG;;
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
echo -e "\n\n***Prepare to paste the SSH account and/or key password multiple times***"
# Allow the remote host to proxychains through localhost
echo -e "\nCreating SSH tunnel to allow proxychains out of the client network through localhost:"
run_ssh_command ssh -fND $O_PORT root@127.0.0.1
run_ssh_command ssh -fNR $O_PORT:localhost:$O_PORT $R_USER@$R_HOST


# Allow proxychains to access the remote host
echo -e "\nCreating SSH tunnel to allow proxychains to access the remote host:"
run_ssh_command ssh -fND $I_PORT $R_USER@$R_HOST 


# Map the remote nessus 8834 port to the local 8834 port
echo -e "\nCreating SSH tunnel to map remote nessus port to local port:"
run_ssh_command ssh -fNL $N_PORT:127.0.0.1:$N_PORT $R_USER@$R_HOST

# This can be used if you need to let the remote host access a local service
# As this is not a common use case, it is commented out
#run_ssh_command ssh -fNR 127.0.0.1:$R_PORT $R_USER@$R_HOST
