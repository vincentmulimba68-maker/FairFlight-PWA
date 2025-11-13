#!/bin/bash
# auto_push_log.sh - automatically run 
# push_all.sh every 5 minutes with logging
LOG_FILE="$HOME/FairFlight-PWA/push_log.txt" 
while true; do
    echo "🔄 Running push_all.sh at $(date)" | 
    tee -a "$LOG_FILE"
    
    # Run push_all.sh and append output to log
    ./push_all.sh 2>&1 | tee -a "$LOG_FILE"
    
    echo "⏱ Sleeping for 5 minutes..." | tee -a 
    "$LOG_FILE" echo 
    "----------------------------------------" 
    | tee -a "$LOG_FILE"
    
    sleep 300 # 300 seconds = 5 minutes
done
