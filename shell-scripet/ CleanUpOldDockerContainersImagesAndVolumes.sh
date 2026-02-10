#!/bin/bash
# Set the disk usage threshold (in percentage)
THRESHOLD=90
# Get the current disk usage percentage for the root filesystem
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
# If disk usage is higher than the threshold, send an alert
if [ $DISK_USAGE -gt $THRESHOLD ]; then
echo "Warning: Disk space is above threshold. Current usage: $DISK_USAGE%"
| mail -s "Disk Space Alert" admin@example.com
fi
# Print success message
echo "Disk space check completed."