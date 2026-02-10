#!/bin/bash
echo "CPU Load:"; uptime
echo -e "\nMemory Usage:"; free -m
echo -e "\nDisk Usage:"; df -h
echo -e "\nTop 5 Memory Consuming Processes:"; ps aux --sort=-%mem | head -n 6