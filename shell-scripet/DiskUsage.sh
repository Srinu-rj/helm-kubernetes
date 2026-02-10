#!/bin/bash
# Set disk usage threshold (in percentage)
THRESHOLD=90
# Get disk usage of root directory
DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
# Check if disk usage exceeds the threshold
if [ $DISK_USAGE -ge $THRESHOLD ]; then
echo "Warning: Disk usage is ${DISK_USAGE}% on /" | mail -s "Disk Usage
Alert" admin@example.com
else
echo "Disk usage is normal: ${DISK_USAGE}%"
fi