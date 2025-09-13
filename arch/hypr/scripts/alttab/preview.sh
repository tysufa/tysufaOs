#!/usr/bin/env bash
line="$1"

IFS=$'\t' read -r addr _ <<< "$line"

preview_lines=$((FZF_PREVIEW_LINES - 2))

dim="${FZF_PREVIEW_COLUMNS}x${preview_lines}"

# hyprctl dispatch exec -- grim -t png -l 0 -w "$addr" ~/.config/hypr/scripts/alttab/preview.png 
# sleep 0.1
# chafa --animate false -s "$dim" ~/.config/hypr/scripts/alttab/preview.png

grim -t png -l 0 -w "$addr" - | \
chafa --animate false -s "$dim" -

# hyprctl dispatch exec -- grim -t png -l 0 -w "$1" ~/.config/hypr/scripts/alttab/preview.png 
# sleep 0.1
# chafa --animate false -s "40x40" ~/.config/hypr/scripts/alttab/preview.png
