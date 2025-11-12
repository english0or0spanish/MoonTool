#!/usr/bin/env bash

# temps/set.sh - Set temperature

if [[ "$1" == --* ]]; then
    HOST="${1#--}"
    shift
else
    echo "Usage: moontool.sh temps set --<ip:port> <hotend|bed> <temperature>"
    exit 1
fi

if [ $# -lt 2 ]; then
    echo "Error: Must specify heater type (hotend/bed) and temperature"
    exit 1
fi

HEATER="$1"
TEMP="$2"

case "$HEATER" in
    hotend)
        GCODE="M104 S${TEMP}"
        ;;
    bed)
        GCODE="M140 S${TEMP}"
        ;;
    *)
        echo "Error: Heater must be 'hotend' or 'bed'"
        exit 1
        ;;
esac

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

ENCODED=$(urlencode "$GCODE")
curl -X POST "http://${HOST}/printer/gcode/script?script=${ENCODED}"