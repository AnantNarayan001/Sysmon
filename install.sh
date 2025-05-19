#!/bin/bash
set -e  # Exit on error

echo "Building kernel module..."
make

if [ ! -f "src/sysmon.ko" ]; then
    echo "Error: Kernel module build failed"
    exit 1
fi

echo "Loading kernel module..."
sudo insmod src/sysmon.ko

if [ $? -eq 0 ]; then
    echo "Module loaded successfully"
    echo "You can view process information with: cat /proc/sysmon"
    echo "Check debug messages with: dmesg | grep SysMon"
else
    echo "Error: Failed to load module"
    exit 1
fi
