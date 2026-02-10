#!/bin/bash
# Define resource thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
# Get current CPU and Memory usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk
'{print 100 - $1}')
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
# Check if CPU usage exceeds threshold
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
echo "CPU usage is high: ${CPU_USAGE}%" | mail -s "CPU Usage Alert"
admin@example.com
fi
# Check if memory usage exceeds threshold
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
echo "Memory usage is high: ${MEMORY_USAGE}%" | mail -s "Memory
Usage Alert" admin@example.com
fi
echo "System resource usage check completed."