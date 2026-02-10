#!/bin/bash
# Get the CPU temperature
CPU_TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
CPU_TEMP_C=$(($CPU_TEMP / 1000))
# Define the threshold temperature (in Celsius)
THRESHOLD=75
# Check if the CPU temperature exceeds the threshold
if [ $CPU_TEMP_C -gt $THRESHOLD ]; then
echo "Warning: High CPU temperature detected: $CPU_TEMP_C°C" | mail -s
"High CPU Temperature Alert" admin@example.com
else
echo "CPU temperature is normal: $CPU_TEMP_C°C"
fi

