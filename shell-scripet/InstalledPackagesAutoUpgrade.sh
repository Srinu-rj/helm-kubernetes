#!/bin/bash
# Check for available updates
sudo apt update -y
# Automatically upgrade packages if updates are available
sudo apt upgrade -y
# Print success message
echo "System packages upgraded successfully."