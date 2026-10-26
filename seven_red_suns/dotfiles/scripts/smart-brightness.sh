#!/usr/bin/env bash
# Usage: smart-brightness.sh +10   OR   smart-brightness.sh -10

DELTA="$1"
STEP="${DELTA#[-+]}" # Strip sign for ddcutil numeric value

# Query Niri IPC for the currently focused display output
FOCUSED_OUTPUT=$(niri msg -j focused-output | jq -r '.name')

# Check if the focused screen is the laptop screen (eDP-1, eDP-2, etc.)
if [[ "$FOCUSED_OUTPUT" == eDP* ]]; then
  # LAPTOP MONITOR: use noctalia
  if [[ "$DELTA" == +* ]]; then
    noctalia msg brightness-up ${STEP}
  else
    noctalia msg brightness-down ${STEP}
  fi
  # Extract current brightness percentage
  CURRENT_VAL=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
else
  # EXTERNAL MONITOR: use ddcutil
  if [[ "$DELTA" == +* ]]; then
    ddcutil setvcp 10 + "$STEP" > /dev/null
  else
    ddcutil setvcp 10 - "$STEP" > /dev/null
  fi
  # Parse current brightness value from ddcutil brief output
  CURRENT_VAL=$(ddcutil getvcp 10 --brief 2>/dev/null | awk '{print $4}')
fi

# Display resulting brightness with noctalia
if [[ -n "$CURRENT_VAL" ]]; then
  noctalia msg brightness-osd $CURRENT_VAL
fi
