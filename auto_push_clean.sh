#!/bin/bash
# auto_push_clean.sh - auto push changes to GitHub every 5 min
# Logs only when actual changes are committed

LOG_FILE="$HOME/FairFlight-PWA/push_clean_log.txt"

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
    
    # Commit with timestamp
    COMMIT_MSG="Automatic update: $NOW"
    git commit -m "$COMMIT_MSG"
    
    # Push to main branch
    git push origin main
    
    # Log the commit
    echo "✅ [$NOW] Pushed changes: $COMMIT_MSG" >> "$LOG_FILE"
    
    sleep 300  # wait 5 minutes
done
