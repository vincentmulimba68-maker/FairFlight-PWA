#!/bin/bash
# Add or update a flight to trigger v4.3 alert
FLIGHTS_FILE=~/FairFlight-PWA/flights.json

# Load existing flights
flights=$(cat $FLIGHTS_FILE)

# Add a new flight (random time for testing)
NEW_FLIGHT='{"from":"Nairobi","to":"Mombasa","time":"19:00","price":200}'

# Append new flight and save
echo $flights | jq '. += ['$NEW_FLIGHT']' > $FLIGHTS_FILE

echo "✅ flights.json updated with a new flight. Check your app for alert!"
