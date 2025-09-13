#!/usr/bin/env bash

STATE_FILE="/tmp/hypr_alt_hold_active"

case "$1" in
  start)
    # Clean slate
    rm -f "$STATE_FILE"
    # Start timer in background
    (
      sleep 0.1
      echo "1" > "$STATE_FILE"
    ) &
    echo $! > /tmp/alt_hold_pid
    ;;
  
  cancel)
    # Kill pending timer
    if [[ -f /tmp/alt_hold_pid ]]; then
      kill "$(cat /tmp/alt_hold_pid)" 2>/dev/null
      rm -f /tmp/alt_hold_pid
    fi
    rm -f "$STATE_FILE"
    ;;

  tab)
    if [[ -f "$STATE_FILE" ]]; then
      # Long hold activated submap; don't override
      hyprctl dispatch submap alttab
      footclient -a alttab ~/.config/hypr/scripts/alttab/alttab.sh
      :
    else
      # Regular quick switch behavior
      footclient -a alttab ~/.config/hypr/scripts/alttab/alttab.sh fast
    fi
    ;;
esac

