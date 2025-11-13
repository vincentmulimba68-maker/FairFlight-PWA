#!/bin/bash
# auto_push_final.sh - fully automatic push script with optional messages and logging

LOG_FILE="$HOME/FairFlight-PWA/push_final_log.txt"

while true; do
    NOW=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Stage all changes
    git add .
    
    # Check if there are changes to commit
    if git diff --cached --quiet; then
        # No changes, skip commit
        sleep 300
        continue
    fi
    
    # Determine commit message
    if [ -z "$1" ]; then
        COMMIT_MSG="Automatic update: $NOW"
    else
        COMMIT_MSG="$1 (updated: $NOW)"
    fi
    
    # Commit and push
    git commit -m "$COMMIT_MSG"
    git push origin main
    
    # Log the commit
    echo "✅ [$NOW] Pushed changes: $COMMIT_MSG" >> "$LOG_FILE"
    
    # Wait before next check
    sleep 300  # 5 minutes
done
