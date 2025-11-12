#!/usr/bin/env bash

# moontool.sh - Main controller for Moonraker CLI tool
# Usage: moontool.sh <module> [function] --<ip:port> [args...]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Check if module specified
if [ $# -lt 1 ]; then
    echo "Usage: moontool.sh <module> [function] --<ip:port> [args...]"
    echo ""
    echo "Available modules:"
    echo "  cooling  - Set all temperatures to 0"
    echo "  gcode    - Send G-code commands"
    echo "  home     - Home all axes"
    echo "  status   - Get printer status"
    echo "  temps    - Get/set temperatures"
    exit 1
fi

MODULE="$1"
shift

# Check if module exists
if [ ! -d "$MODULES_DIR/$MODULE" ]; then
    echo "Error: Module '$MODULE' not found"
    exit 1
fi

# Determine which function to call
# Check if next arg looks like a function (doesn't start with --)
if [ $# -gt 0 ] && [[ "$1" != --* ]]; then
    FUNCTION="$1"
    shift
    SCRIPT="$MODULES_DIR/$MODULE/$FUNCTION.sh"
else
    # Try main.sh first, then get.sh as fallback
    if [ -f "$MODULES_DIR/$MODULE/main.sh" ]; then
        SCRIPT="$MODULES_DIR/$MODULE/main.sh"
    elif [ -f "$MODULES_DIR/$MODULE/get.sh" ]; then
        SCRIPT="$MODULES_DIR/$MODULE/get.sh"
    else
        echo "Error: No default function found for module '$MODULE'"
        exit 1
    fi
fi

# Check if script exists
if [ ! -f "$SCRIPT" ]; then
    echo "Error: Function script not found: $SCRIPT"
    exit 1
fi

# Execute the module script with remaining args
bash "$SCRIPT" "$@"