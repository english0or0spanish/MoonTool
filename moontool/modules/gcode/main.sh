#!/usr/bin/env bash

# gcode/main.sh - Send G-code commands

if [[ "$1" == --* ]]; then
    HOST="${1#--}"
    shift
else
    echo "Usage: moontool.sh gcode --<ip:port> <gcode_command>"
    exit 1
fi

if [ -z "$*" ]; then
    echo "Error: No G-code command provided"
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

GCODE="$*"
ENCODED=$(urlencode "$GCODE")

curl -X POST "http://${HOST}/printer/gcode/script?script=${ENCODED}"