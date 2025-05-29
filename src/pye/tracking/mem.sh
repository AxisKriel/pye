#!/bin/bash
# This script tracks MEM usage of the firmware process every 60 seconds into a file

INTERVAL=60 # Interval in seconds
DIR="/var/log/pye/tracking/mem"
CURRENT_DATE=$(date +%s)

# Wait for the process to start
while [ -z "$PID" ]; do
    # Get the PID of the firmware process
    PID=$(pgrep -xf "/usr/bin/python3 /firmware/app/run.py")
    if [ -z "$PID" ]; then
        sleep 5 # Wait for 5 seconds before checking again
    fi
done

# Ensure dir exists
mkdir -p $DIR

# Run pidstat with one-line outputs (-h) and ISO timestamps (-H) to track MEM usage (-r) into a timestamped log file
pidstat -h -H -p $PID -r $INTERVAL >> "$DIR/$CURRENT_DATE.log"