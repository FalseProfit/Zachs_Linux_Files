#!/bin/bash

# Validate argument input
if [ -z "$1" ]; then
    echo "[!] Error: Target hostname required."
    echo "[*] Usage: $0 <hostname>"
    exit 1
fi

TARGET=$1

# Array of distinct global DNS resolvers to simulate diverse geographic queries
# Includes: Google, Cloudflare, Quad9, OpenDNS, Comodo
RESOLVERS=(
    "8.8.8.8"
    "1.1.1.1"
    "9.9.9.9"
    "208.67.222.222"
    "8.26.56.26"
)

echo "[*] Enumerating A records for $TARGET..."

# Create a temporary file for raw output
TMP_FILE=$(mktemp)

# Iterate through resolvers and append output
for resolver in "${RESOLVERS[@]}"; do
    # Execute dig: +short limits output, +time=2 sets timeout to prevent hanging on dropped packets
    echo "Querying $resolver"
    dig @"$resolver" A "$TARGET" +short +time=2 2>/dev/null >> "$TMP_FILE"
done

echo "[+] Unique IPv4 addresses identified:"
# Isolate valid IPv4 addresses (filtering out CNAME responses), sort, and deduplicate
grep -E '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' "$TMP_FILE" | sort -uV

# Purge temporary file
rm "$TMP_FILE"