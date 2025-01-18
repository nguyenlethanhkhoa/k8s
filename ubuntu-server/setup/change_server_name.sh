#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Check if a new hostname is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <new-hostname>"
  exit 1
fi

NEW_HOSTNAME=$1

# Update the /etc/hostname file
echo "$NEW_HOSTNAME" > /etc/hostname

# Update the /etc/hosts file
sed -i "s/127\.0\.1\.1.*/127.0.1.1 $NEW_HOSTNAME/" /etc/hosts

# Apply the hostname change immediately
hostnamectl set-hostname "$NEW_HOSTNAME"

# Print the new hostname
echo "Hostname updated successfully to: $NEW_HOSTNAME"

# Reboot notice
read -p "Reboot is recommended for changes to fully take effect. Reboot now? (y/n): " REBOOT
if [[ "$REBOOT" =~ ^[Yy]$ ]]; then
  reboot
else
  echo "Please reboot the server later to ensure all changes take effect."
fi