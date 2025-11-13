#!/bin/bash
# auto_push_notify.sh - auto push with optional message, log rotation, and Termux notifications

LOG_FILE="$HOME/FairFlight-PWA/push_notify_log.txt"
MAX_LINES=1000   # Maximum lines before rotating the log
ROTATED_LOG="$HOME/FairFlight-PWA/push_notify_log.old"

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
    
    # Send Termux notification
    termux-notification --title "FairFlight Update" --content "$COMMIT_MSG"
    
    # Wait 5 minutes before next check
    sleep 300
done
