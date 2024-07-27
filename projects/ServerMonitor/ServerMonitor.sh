#!/bin/bash

SCRIPT_DIR="$(pwd)"

SERVER="onet.pl"
LOG_FILE="$SCRIPT_DIR/server_status.log"

function sendEmail() {
    echo "Subject: Server Down Alert"
}

while true; do
    if ! /c/Windows/System32/ping.exe -n 1 "$SERVER" &> /dev/null; then
        echo "$(date): $SERVER is down" >> "$LOG_FILE"
        sendEmail
    else
        echo "$(date): $SERVER is up" >> "$LOG_FILE"
    fi
    sleep 300  # Sprawdza co 5 minut
done
