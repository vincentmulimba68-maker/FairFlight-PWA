#!/bin/bash
# auto_push_backup.sh - smart multi-type auto push with backups, log rotation, and Termux notifications

LOG_FILE="$HOME/FairFlight-PWA/push_backup_log.txt"
MAX_LINES=1000   # Maximum lines before rotating the log
ROTATED_LOG="$HOME/FairFlight-PWA/push_backup_log.old"
BACKUP_DIR="$HOME/FairFlight-PWA/backups"

mkdir -p "$BACKUP_DIR"

# Define update types and their intervals (in seconds)
UPDATE_CONFIG=(
    "Flight Data:300"       # every 5 minutes
    "UI Update:1800"        # every 30 minutes
    "Bug Fix:600"           # every 10 minutes
    "Feature Update:3600"   # every 1 hour
)

INDEX=0
TOTAL_TYPES=${#UPDATE_CONFIG[@]}

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

    # Extract current update type and interval
    CURRENT_CONFIG=${UPDATE_CONFIG[$INDEX]}
    UPDATE_TYPE=$(echo $CURRENT_CONFIG | cut -d':' -f1)
    INTERVAL=$(echo $CURRENT_CONFIG | cut -d':' -f2)
    
    # Stage all changes
    git add .
    
    # Check if there are changes to commit
    if git diff --cached --quiet; then
        # No changes: skip wait, go to next type immediately
        INDEX=$(( (INDEX + 1) % TOTAL_TYPES ))
        continue
    fi
    
    # Commit and push
    COMMIT_MSG="$UPDATE_TYPE (updated: $NOW)"
    git commit -m "$COMMIT_MSG"
    git push origin main
    
    # Log the commit
    echo "✅ [$NOW] Pushed changes: $COMMIT_MSG" >> "$LOG_FILE"
    
    # Send Termux notification
    termux-notification --title "FairFlight Update" --content "$COMMIT_MSG"
    
    # Create a timestamped backup of the repo
    BACKUP_NAME="FairFlight_PWA_backup_$(date +'%Y%m%d_%H%M%S').tar.gz"
    tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$HOME" "FairFlight-PWA"
    
    # Wait for the interval before next type
    sleep $INTERVAL
    
    # Move to next update type
    INDEX=$(( (INDEX + 1) % TOTAL_TYPES ))
done
