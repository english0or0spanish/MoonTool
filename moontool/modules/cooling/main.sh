#!/usr/bin/env bash

# cooling/main.sh - Set all temperatures to 0

if [[ "$1" == --* ]]; then
    HOST="${1#--}"
    shift
else
    echo "Usage: moontool.sh cooling --<ip:port>"
    exit 1
fi

# URL encode function
urlencode() {
    local string="$1"
    local strlen=${#string}
    local encoded=""
    local pos c o
    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9] ) o="${c}" ;;
            * ) printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"
}

# Set hotend to 0
HOTEND_CMD="M104 S0"
ENCODED_HOTEND=$(urlencode "$HOTEND_CMD")
curl -X POST "http://${HOST}/printer/gcode/script?script=${ENCODED_HOTEND}"

echo ""

# Set bed to 0
BED_CMD="M140 S0"
ENCODED_BED=$(urlencode "$BED_CMD")
curl -X POST "http://${HOST}/printer/gcode/script?script=${ENCODED_BED}"