#!/bin/bash
#Author: Ellery Weber
#Modified by Zach Johnson

# Print the help text, then exit with the status provided to this function.
# A status of 0 means the user requested help. A status of 1 means there was an error.
usage() {
    echo -e 'This script sets up SSH tunnels that are useful during internal penetration testing engagements in which a remote "rogue device" is placed inside the target network and the tester needs to access services on the remote host and/or use proxychains to pivot through the remote host to access other hosts in the target network.\n'
    echo -e "Usage: $0 hostname.domain.com [port options] [tunnel selectors]\n"
    echo "The remote hostname must be the first argument, followed by optional arguments in any order."
    echo
    echo "Options are:"
    echo "  -U <user>: Username used to connect to the remote host (default: root)"
    echo "  -u <user>: Username used to connect to 127.0.0.1 (default: root)"
    echo "  -O <port>: REMOTE outbound traffic THROUGH LOCAL SOCKS proxy port (default: 9050)"
    echo "  -I <port>: LOCAL proxy port used to access the REMOTE network (default: 9999)"
    echo "  -N <port>: Local port used to access remote Nessus (default: 8834)"
    echo "  -R <port>: Port used on both ends when REMOTE accesses a LOCAL service (default: 8000)"
    echo
    echo "Tunnel selectors are:"
    echo "  --outbound-proxy: Allow the remote host to use the local SOCKS proxy"
    echo "  --inbound-proxy: Create a local SOCKS proxy into the remote network"
    echo "  --nessus: Forward the remote Nessus port to the local machine"
    echo "  --remote-to-local: Allow the remote host to access a local service"
    echo
    echo "If no tunnel selectors are provided, all four tunnel groups are created."
    echo "If one or more selectors are provided, only the selected tunnel groups are created."
    echo "Use --help or -h anywhere in the command to display this help text."

    exit "$1"
}

# Check for help before checking any other arguments. This makes --help and -h
# work even if they appear after an invalid or incomplete option.
for ARGUMENT in "$@"; do
    if [ "$ARGUMENT" = "--help" ] || [ "$ARGUMENT" = "-h" ]; then
        usage 0
    fi
done

# Default ports
O_PORT=9050
I_PORT=9999
N_PORT=8834
R_PORT=8000

# Default users. The local user is used only for the localhost SSH connection
# created as part of the outbound proxy tunnel.
R_USER=root
L_USER=root

# Each selector starts as disabled. If the user does not provide any selectors,
# all four will be enabled after the arguments have been read.
SELECTOR_USED=0
OUTBOUND_PROXY=0
INBOUND_PROXY=0
NESSUS=0
REMOTE_TO_LOCAL=0

# The remote hostname is required and must remain the first argument.
if [ -z "$1" ] || [[ "$1" = -* ]]; then
    echo "Error: Hostname is required as the first argument." >&2
    usage 1
fi

R_HOST="$1"
shift

# Read the port options and tunnel selectors. A while/case loop is used because
# the built-in getopts command does not support descriptive long options.
while [ "$#" -gt 0 ]; do
    case "$1" in
        -O|-I|-N|-R|-U|-u)
            # Each of these options must be followed by a value.
            if [ "$#" -lt 2 ] || [ -z "$2" ] || [[ "$2" = -* ]]; then
                echo "Error: $1 requires a value." >&2
                usage 1
            fi

            case "$1" in
                -O) O_PORT="$2";;
                -I) I_PORT="$2";;
                -N) N_PORT="$2";;
                -R) R_PORT="$2";;
                -U) R_USER="$2";;
                -u) L_USER="$2";;
            esac
            shift 2
            ;;
        --outbound-proxy)
            OUTBOUND_PROXY=1
            SELECTOR_USED=1
            shift
            ;;
        --inbound-proxy)
            INBOUND_PROXY=1
            SELECTOR_USED=1
            shift
            ;;
        --nessus)
            NESSUS=1
            SELECTOR_USED=1
            shift
            ;;
        --remote-to-local)
            REMOTE_TO_LOCAL=1
            SELECTOR_USED=1
            shift
            ;;
        --help|-h)
            # Help is handled before parsing, but this keeps the case list complete.
            usage 0
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            usage 1
            ;;
        *)
            echo "Error: Unexpected argument: $1" >&2
            usage 1
            ;;
    esac
done

# Running without selectors keeps the convenient behavior of creating every tunnel.
if [ "$SELECTOR_USED" -eq 0 ]; then
    OUTBOUND_PROXY=1
    INBOUND_PROXY=1
    NESSUS=1
    REMOTE_TO_LOCAL=1
fi

# Check that a port contains only numbers and is within the valid TCP port range.
validate_port() {
    PORT_NAME="$1"
    PORT_VALUE="$2"

    case "$PORT_VALUE" in
        ''|*[!0-9]*)
            echo "Error: $PORT_NAME must be a whole number from 1 through 65535." >&2
            exit 1
            ;;
    esac

    # More than five digits can never be a valid TCP port.
    if [ "${#PORT_VALUE}" -gt 5 ] || [ "$PORT_VALUE" -lt 1 ] || [ "$PORT_VALUE" -gt 65535 ]; then
        echo "Error: $PORT_NAME must be a whole number from 1 through 65535." >&2
        exit 1
    fi
}

# Validate every configured port before starting any SSH processes.
validate_port "-O port" "$O_PORT"
validate_port "-I port" "$I_PORT"
validate_port "-N port" "$N_PORT"
validate_port "-R port" "$R_PORT"

# Stop before creating tunnels if the OpenSSH client is not installed or not in PATH.
if ! command -v ssh >/dev/null 2>&1; then
    echo "Error: The ssh command was not found in PATH." >&2
    exit 1
fi

# Run one SSH command and stop if it fails. The tunnel name makes the error clear.
run_ssh_command() {
    TUNNEL_NAME="$1"
    shift

    "$@"
    SSH_STATUS=$?

    if [ "$SSH_STATUS" -ne 0 ]; then
        echo "Error: Failed to create the $TUNNEL_NAME tunnel (ssh exited with status $SSH_STATUS)." >&2
        echo "Any tunnels started earlier by this script may still be running." >&2
        exit "$SSH_STATUS"
    fi
}

# ExitOnForwardFailure makes SSH report a bind or forwarding failure before it
# moves into the background. This lets run_ssh_command catch the problem.
echo -e "\n\n***Prepare to paste the SSH account and/or key password multiple times***"

if [ "$OUTBOUND_PROXY" -eq 1 ]; then
    # Allow the remote host to proxychains through localhost.
    echo -e "\nCreating SSH tunnel to allow proxychains out of the client network through localhost:"
    run_ssh_command "local outbound SOCKS proxy" ssh -o ExitOnForwardFailure=yes -fND "$O_PORT" "$L_USER@127.0.0.1"
    run_ssh_command "remote connection to the outbound SOCKS proxy" ssh -o ExitOnForwardFailure=yes -fNR "$O_PORT:localhost:$O_PORT" "$R_USER@$R_HOST"
fi

if [ "$INBOUND_PROXY" -eq 1 ]; then
    # Allow local proxychains to access hosts on the remote network.
    echo -e "\nCreating SSH tunnel to allow proxychains to access the remote network:"
    run_ssh_command "inbound SOCKS proxy" ssh -o ExitOnForwardFailure=yes -fND "$I_PORT" "$R_USER@$R_HOST"
fi

if [ "$NESSUS" -eq 1 ]; then
    # Map the remote Nessus port to the same port on the local machine.
    echo -e "\nCreating SSH tunnel to map the remote Nessus port to the local port:"
    run_ssh_command "Nessus" ssh -o ExitOnForwardFailure=yes -fNL "$N_PORT:127.0.0.1:$N_PORT" "$R_USER@$R_HOST"
fi

if [ "$REMOTE_TO_LOCAL" -eq 1 ]; then
    # Let the remote host reach a service bound to the same port on localhost.
    echo -e "\nCreating SSH tunnel to let the remote host access a local service:"
    run_ssh_command "remote-to-local service" ssh -o ExitOnForwardFailure=yes -fNR "$R_PORT:127.0.0.1:$R_PORT" "$R_USER@$R_HOST"
fi

echo -e "\nAll selected SSH tunnels started successfully."
