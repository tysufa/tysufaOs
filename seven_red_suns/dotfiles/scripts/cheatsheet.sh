#!/usr/bin/env bash

export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"

DIR="$HOME/cheatsheets/pdf"

if [ ! -d "$DIR" ]; then
    echo "Error: Directory $DIR does not exist."
    exit 1
fi

# Process substitution keeps fzf TTY bindings clean inside $(...)
FILE=$(fzf < <(ls -1 "$DIR"))

if [ -n "$FILE" ]; then
    setsid xdg-open "$DIR/$FILE" >/dev/null 2>&1
    # systemd-run --user --scope --quiet xdg-open "$DIR/$FILE" &
fi
