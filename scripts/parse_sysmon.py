#!/usr/bin/env python3
with open("/proc/sysmon") as f:
    for line in f:
        print(line.strip())
