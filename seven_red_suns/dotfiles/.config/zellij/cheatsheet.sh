#!/usr/bin/env bash

DIR="$HOME/cheatsheets/pdf"

FILE=$(ls "$DIR" | fzf)

if [ -n "$FILE" ]; then
    systemd-run --user --scope xdg-open "$DIR/$FILE" >/dev/null 2>&1
fi
