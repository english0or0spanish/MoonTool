#!/usr/bin/env bash

# status/main.sh - Get printer status

if [[ "$1" == --* ]]; then
    HOST="${1#--}"
    shift
else
    echo "Usage: moontool.sh status --<ip:port>"
    exit 1
fi

# Get the raw JSON response
RESPONSE=$(curl -s "http://${HOST}/printer/objects/query?print_stats&toolhead&heater_bed&extruder")

# Parse and display status
STATE=$(echo "$RESPONSE" | sed -n 's/.*"state":[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)

# Display printer state
case "$STATE" in
    standby|ready)
        echo "Status: Idle"
        ;;
    printing)
        echo "Status: Printing"
        ;;
    paused)
        echo "Status: Paused"
        ;;
    complete)
        echo "Status: Print Complete"
        ;;
    cancelled)
        echo "Status: Cancelled"
        ;;
    error)
        echo "Status: Error"
        ;;
    *)
        echo "Status: $STATE"
        ;;
esac

# Show current file if printing
FILENAME=$(echo "$RESPONSE" | sed -n 's/.*"filename":[[:space:]]*"\([^"]*\)".*/\1/p')
if [ ! -z "$FILENAME" ] && [ "$STATE" != "standby" ]; then
    echo "File: $FILENAME"
fi

# Show temps
HOTEND_TEMP=$(echo "$RESPONSE" | sed -n 's/.*"extruder":[[:space:]]*{[^}]*"temperature":[[:space:]]*\([0-9.]*\).*/\1/p' | head -1)
HOTEND_TARGET=$(echo "$RESPONSE" | sed -n 's/.*"extruder":[[:space:]]*{[^}]*"target":[[:space:]]*\([0-9.]*\).*/\1/p' | head -1)
BED_TEMP=$(echo "$RESPONSE" | sed -n 's/.*"heater_bed":[[:space:]]*{[^}]*"temperature":[[:space:]]*\([0-9.]*\).*/\1/p' | head -1)
BED_TARGET=$(echo "$RESPONSE" | sed -n 's/.*"heater_bed":[[:space:]]*{[^}]*"target":[[:space:]]*\([0-9.]*\).*/\1/p' | head -1)

echo "Hotend: ${HOTEND_TEMP}°C / ${HOTEND_TARGET}°C"
echo "Bed: ${BED_TEMP}°C / ${BED_TARGET}°C"