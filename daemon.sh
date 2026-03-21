#!/bin/bash
# EGOS SSOT Daemon
# Runs the master sync.sh script every 60 seconds to enforce OS-level governance

WAIT_SECONDS=60

echo "Starting EGOS SSOT Daemon. Sync interval: ${WAIT_SECONDS}s"

while true; do
  # Execute sync silently to avoid massive log files
  /home/enio/.egos/sync.sh > /dev/null 2>&1
  sleep $WAIT_SECONDS
done
