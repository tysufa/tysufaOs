#!/usr/bin/env bash

# ----- WOFI LAUNCHER -----

# CONFIG="$HOME/.config/wofi/config/config"
# STYLE="$HOME/.config/wofi/src/mocha/style.css"
#
# if [[ ! $(pidof wofi) ]]; then
#     wofi --show drun --conf "${CONFIG}" --style "${STYLE}"
# else
#     pkill wofi
# fi


# -------- VICINAE LAUNCHER ------------
if vicinae ping >/dev/null 2>&1; then
    # Server is already running
    vicinae toggle
else
    # Start server in background and detach it
    vicinae server >/dev/null 2>&1 &
    disown

    # Wait for the server socket to become responsive (up to 3 seconds)
    for i in {1..30}; do
        if vicinae ping >/dev/null 2>&1; then
            break
        fi
        sleep 0.1
    done

    # Open the UI once ready
    vicinae toggle
fi

