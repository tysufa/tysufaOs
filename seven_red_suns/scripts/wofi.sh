#!/usr/bin/env bash

CONFIG="$HOME/.config/wofi/config/config"
STYLE="$HOME/.config/wofi/src/mocha/style.css"

if [[ ! $(pidof wofi) ]]; then
    wofi --show drun --conf "${CONFIG}" --style "${STYLE}"
else
    pkill wofi
fi
