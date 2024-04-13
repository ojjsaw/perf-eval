#!/bin/bash

bash run_fp32_experiment.sh

echo "Copying results and system info."

mkdir -p /results
cp /app/*.png /results/

# Get CPU information
cpu_info=$(lscpu | grep "Model name" | awk -F ':' '{print $2}' | xargs)

# Get RAM in GB
ram_info=$(free -g | grep Mem | awk '{print $2 " GB"}')

# Get OS version
os_info=$(lsb_release -a 2>/dev/null | grep Description | awk -F ':' '{print $2}' | xargs)

# Write to a text file
echo "CPU: $cpu_info" > /results/system_info.txt
echo "RAM: $ram_info" >> /results/system_info.txt
echo "OS: $os_info" >> /results/system_info.txt

echo "Completed copy result data and system info."

sleep 3