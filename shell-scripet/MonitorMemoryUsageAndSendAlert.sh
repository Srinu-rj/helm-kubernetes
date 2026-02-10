#!/bin/bash
# Set the memory usage threshold (in percentage)
THRESHOLD=80
# Get the current memory usage percentage
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
# Check if memory usage exceeds the threshold
if (( $(echo "$MEMORY_USAGE > $THRESHOLD" | bc -l) )); then
echo "Memory usage is high: $MEMORY_USAGE%" | mail -s "High Memory
Usage Alert" admin@example.com
echo "Alert sent."
else
echo "Memory usage is normal: $MEMORY_USAGE%"
fi
