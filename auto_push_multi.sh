#!/bin/bash
# auto_push_multi.sh - auto push with optional type-based messages, log rotation, and Termux notifications

LOG_FILE="$HOME/FairFlight-PWA/push_multi_log.txt"
MAX_LINES=1000   # Maximum lines before rotating the log
ROTATED_LOG="$HOME/FairFlight-PWA/push_multi_log.old"

# Default update type if none is provided
UPDATE_TYPE=${1:-"General Update"}

while true; do
    NOW=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Rotate log if it exceeds MAX_LINES
    if [ -f "$LOG_FILE" ]; then
        LINES=$(wc -l < "$LOG_FILE")
        if [ "$LINES" -ge "$MAX_LINES" ]; then
            mv "$LOG_FILE" "$ROTATED_LOG"
            echo "📝 Log rotated at $NOW" > "$LOG_FILE"
        fi
    fi

    # Stage all changes
    git add .
    
    # Check if there are changes to commit
    if git diff --cached --quiet; then
        sleep 300
        continue
    fi
    
    # Commit message includes update type and timestamp
    COMMIT_MSG="$UPDATE_TYPE (updated: $NOW)"
    
    # Commit and push
    git commit -m "$COMMIT_MSG"
    git push origin main
    
    # Log the commit
    echo "✅ [$NOW] Pushed changes: $COMMIT_MSG" >> "$LOG_FILE"
    
    # Send Termux notification
    termux-notification --title "FairFlight Update" --content "$COMMIT_MSG"
    
    # Wait 5 minutes before next check
    sleep 300
done
