#!/bin/bash

# Check if an IP address is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <ip_address>"
    echo "Example: $0 192.168.50.1/24"
    exit 1
fi

# Assign the argument to a variable
IP_ADDRESS=$1

# Input and output file paths
TEMPLATE_FILE="netplan.template.yaml"
OUTPUT_FILE="/tmp/50-cloud-init.yaml"

# Check if the template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found!"
    exit 1
fi

# Replace {ip_address} with the provided IP address and save to output file
sed "s/{ip_address}/$IP_ADDRESS/" "$TEMPLATE_FILE" > "$OUTPUT_FILE"
sudo cp $OUTPUT_FILE /etc/netplan/50-cloud-init.yaml

# Check if the operation was successful
if [ $? -eq 0 ]; then
    echo "Netplan configuration generated successfully in '$OUTPUT_FILE'."
else
    echo "Error: Failed to generate the netplan configuration."
    exit 1
fi