#!/bin/bash
set -e  # Exit on error

echo "Unloading kernel module..."
sudo rmmod sysmon

if [ $? -eq 0 ]; then
    echo "Module unloaded successfully"
else
    echo "Error: Failed to unload module"
    exit 1
fi
