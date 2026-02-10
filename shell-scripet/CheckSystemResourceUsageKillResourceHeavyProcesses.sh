#!/bin/bash
# Get the top 5 resource-heavy processes
TOP_PROCESSES=$(ps aux --sort=-%cpu | head -n 6)
# Print the top processes
echo "Top 5 resource-heavy processes:"
echo "$TOP_PROCESSES"
# Kill the highest resource-heavy process (if CPU > 80%)
CPU_USAGE=$(echo "$TOP_PROCESSES" | head -n 2 | tail -n 1 | awk '{print
$3}')
PID=$(echo "$TOP_PROCESSES" | head -n 2 | tail -n 1 | awk '{print $2}')
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
echo "Killing process with PID $PID due to high CPU usage ($CPU_USAGE%)"
kill -9 $PID
else
echo "No process exceeds CPU usage threshold."
fi