#!/bin/bash
# auto_push.sh - automatically run push_all.sh 
# every 5 minutes
while true; do echo "🔄 Running push_all.sh at 
    $(date)" ./push_all.sh echo "⏱ Sleeping for 
    5 minutes..." sleep 300 # 300 seconds = 5 
    minutes
done
