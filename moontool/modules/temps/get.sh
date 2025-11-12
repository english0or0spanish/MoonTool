#!/usr/bin/env bash

# temps/get.sh - Get current temperatures

if [[ "$1" == --* ]]; then
    HOST="${1#--}"
    shift
else
    echo "Usage: moontool  temps --<ip:port> [Get]"
   echo "Usage: moontool temps set --<ip:port> bed/hotend temp [Set]"
    exit 1
fi

# Get the raw JSON response
RESPONSE=$(curl -s "http://${HOST}/printer/objects/query?extruder&heater_bed")

# Parse temps using sed
HOTEND_TEMP=$(echo "$RESPONSE" | sed -n 's/.*"extruder":[[:space:]]*{[^}]*"temperature":[[:space:]]*\([0-9.]*\).*/\1/p' | head -1)
HOTEND_TARGET=$(echo "$RESPONSE" | sed -n 's/.*"extruder":[[:space:]]*{[^}]*"target":[[:space:]]*\([0-9.]*\).*/\1/p' | head -1)
BED_TEMP=$(echo "$RESPONSE" | sed -n 's/.*"heater_bed":[[:space:]]*{[^}]*"temperature":[[:space:]]*\([0-9.]*\).*/\1/p' | head -1)
BED_TARGET=$(echo "$RESPONSE" | sed -n 's/.*"heater_bed":[[:space:]]*{[^}]*"target":[[:space:]]*\([0-9.]*\).*/\1/p' | head -1)

echo "Hotend: ${HOTEND_TEMP}°C / ${HOTEND_TARGET}°C"
echo "Bed: ${BED_TEMP}°C / ${BED_TARGET}°C"