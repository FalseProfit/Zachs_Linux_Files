#!/bin/bash

# Specify the range of IP addresses to scan and the list of ports
IP_RANGE="192.168.1.0/24"
PORTS=(22 80 443 8080 3306 3389 445 5985 389 636)  # Add or remove ports as needed
TEMP_RANDOM=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

# Create a temporary file to store results
#RESULTS_FILE=$(mktemp)

# Scan each port asynchronously
for port in "${PORTS[@]}"; do
	echo "Scanning for open port $port..."
 	masscan $IP_RANGE -p$port --rate=75 >> masscan_temp$TEMP_RANDOM$port.txt &
done

# Wait for all background scans to finish
wait

# Extract and print the unique IP addresses with open ports
for port in "${PORTS[@]}"; do
	cat masscan_temp$port.txt | awk '/open/ {print $6}' | sort -u >> masscan_port$port.txt
 	# Clean up the temporary file
  	rm masscan_temp$TEMP_RANDOM$port.txt
done

