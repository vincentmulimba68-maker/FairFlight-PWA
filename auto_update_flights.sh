#!/bin/bash
LOG_FILE=~/FairFlight-PWA/update_log.txt
UPDATE_SCRIPT=~/FairFlight-PWA/update_flights_random.sh

echo "=== Auto Update Script Started at $(date) ===" >> "$LOG_FILE"

while true
do
    if [ ! -f "$UPDATE_SCRIPT" ]; then
        echo "[$(date)] ⚠️ Missing update script: $UPDATE_SCRIPT" >> "$LOG_FILE"
        sleep 60
        continue
    fi

    echo "[$(date)] Running flight data update..." >> "$LOG_FILE"
    bash "$UPDATE_SCRIPT" >> "$LOG_FILE" 2>&1
    echo "[$(date)] ✅ Flight update completed." >> "$LOG_FILE"

    sleep 300
done
