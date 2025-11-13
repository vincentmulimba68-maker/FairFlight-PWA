#!/bin/bash
APP_DIR="$HOME/FairFlight-PWA"
UPDATE_SCRIPT="$APP_DIR/auto_update_flights.sh"
LOG_FILE="$APP_DIR/watchdog_log.txt"

echo "=== Watchdog Started at $(date) ===" >> "$LOG_FILE"

while true; do
    if ! pgrep -f "$UPDATE_SCRIPT" > /dev/null; then
        echo "[$(date)] ⚠️ auto_update_flights.sh not running. Restarting..." >> "$LOG_FILE"
        nohup bash "$UPDATE_SCRIPT" >> "$APP_DIR/update_log.txt" 2>&1 &
        echo "[$(date)] ✅ auto_update_flights.sh restarted." >> "$LOG_FILE"
    fi
    sleep 60
done
