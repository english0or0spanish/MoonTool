#!/usr/bin/env bash

# home/main.sh - Home all axes

if [[ "$1" == --* ]]; then
    HOST="${1#--}"
    shift
else
    echo "Usage: moontool.sh home --<ip:port>"
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

GCODE="G28"
ENCODED=$(urlencode "$GCODE")

curl -X POST "http://${HOST}/printer/gcode/script?script=${ENCODED}"