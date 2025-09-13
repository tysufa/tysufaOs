#!/bin/bash

# If clicked, store the last GPU mode in a temp file (still technically "no config file")
TMP_STATE="/tmp/waybar_gpu_toggle_state"

# Initialize default GPU
DEFAULT_GPU="amd"

# If click event, switch GPU mode
if [[ "$1" == "click" ]]; then
  # Read previous state from /tmp, fallback to default
  CURRENT=$(cat "$TMP_STATE" 2>/dev/null || echo "$DEFAULT_GPU")
  NEW_STATE="nvidia"
  [[ "$CURRENT" == "nvidia" ]] && NEW_STATE="amd"
  echo "$NEW_STATE" > "$TMP_STATE"
  exit 0
fi

# Not a click: read current state (for display)
CURRENT=$(cat "$TMP_STATE" 2>/dev/null || echo "$DEFAULT_GPU")

# Show info for current GPU
json=$(nvtop -s 2>/dev/null)
if [[ "$CURRENT" == "nvidia" ]]; then
  nvidia=$(echo "$json" | jq -r '.[] | select(.device_name | test("NVIDIA")) | "\(.gpu_util) @ \(.temp)"')
  [[ -z "$nvidia" ]] && echo "NVIDIA: off" && exit 0
  echo "NVIDIA: $nvidia"
else
  amd=$(echo "$json" | jq -r '.[] | select(.device_name | test("AMD")) | "\(.gpu_util) @ \(.temp)"')
  [[ -z "$amd" ]] && echo "AMD: off" && exit 0
  echo "AMD: $amd"
fi

