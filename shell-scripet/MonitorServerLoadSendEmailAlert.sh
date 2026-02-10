#!/bin/bash
# Set the load threshold (load average over the last 1 minute)
THRESHOLD=2.0
# Get the current load average
LOAD=$(uptime | awk '{print $10}' | sed 's/,//')
# Check if the load is greater than the threshold
if (( $(echo "$LOAD > $THRESHOLD" | bc -l) )); then
echo "Server load is high: $LOAD" | mail -s "High Server Load Alert"
admin@example.com
echo "Alert sent."
else
echo "Server load is normal: $LOAD"
fi