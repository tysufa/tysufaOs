#!/usr/bin/env bash

# Launch Deezer
deezer-desktop &

# Wait for window to map
sleep 0.7

# Get Deezer Window ID
WINDOW_ID=$(niri msg windows | grep -B 2 "dev.aunetx.deezer" | head -n 1 | awk '{print $3}' | tr -d ':')

if [ -n "$WINDOW_ID" ]; then
    # 1. Turn into a floating window
    niri msg action toggle-window-floating --id "$WINDOW_ID"

    # 2. Set width and height to 95%
    niri msg action set-column-width "90%" --id "$WINDOW_ID"
    niri msg action set-window-height "90%" --id "$WINDOW_ID"

    # 3. Center on screen
    niri msg action center-window --id "$WINDOW_ID"
fi
