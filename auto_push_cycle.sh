#!/bin/bash
# auto_push_cycle.sh - auto push with multiple update types, log rotation, and Termux notifications

LOG_FILE="$HOME/FairFlight-PWA/push_cycle_log.txt"
MAX_LINES=1000   # Maximum lines before rotating the log
ROTATED_LOG="$HOME/FairFlight-PWA/push_cycle_log.old"

# Define the list of update types
UPDATE_TYPES=("Flight Data" "UI Update" "Bug Fix" "Feature Update")

# Index to cycle through update types
INDEX=0
TOTAL_TYPES=${#UPDATE_TYPES[@]}

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
    
    # Determine current update type
    UPDATE_TYPE=${UPDATE_TYPES[$INDEX]}
    COMMIT_MSG="$UPDATE_TYPE (updated: $NOW)"
    
    # Commit and push
    git commit -m "$COMMIT_MSG"
    git push origin main
    
    # Log the commit
    echo "✅ [$NOW] Pushed changes: $COMMIT_MSG" >> "$LOG_FILE"
    
    # Send Termux notification
    termux-notification --title "FairFlight Update" --content "$COMMIT_MSG"
    
    # Move to next update type
    INDEX=$(( (INDEX + 1) % TOTAL_TYPES ))
    
    # Wait 5 minutes before next check
    sleep 300
done
