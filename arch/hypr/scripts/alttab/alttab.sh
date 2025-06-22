#!/usr/bin/env bash

case "$1" in
  fast)
    address=$(hyprctl -j clients | jq -r '[sort_by(.focusHistoryID) | .[] | select(.workspace.id >= 0)] | .[1] | "\(.address)"')
    hyprctl --batch -q "dispatch focuswindow address:$address;dispatch alterzorder top"
    exit
    ;;
  *)
    echo "Unknown argument: $1"
    ;;
esac


address=$(hyprctl -j clients | jq -r 'sort_by(.focusHistoryID) | .[] | select(.workspace.id >= 0) | "\(.address)\t\(.title)"' |
	      fzf --color prompt:green,pointer:green,current-bg:-1,current-fg:green,gutter:-1,border:bright-black,current-hl:red,hl:red \
		  --cycle \
		  --sync \
		  --bind tab:down,shift-tab:up,start:down,double-click:ignore \
		  --wrap \
		  --delimiter=$'\t' \
		  --with-nth=2 \
		  --preview "~/.config/hypr/scripts/alttab/preview.sh {}" \
		  --preview-window=down:90% \
		  --layout=reverse|
	      awk -F"\t" '{print $1}')

if [ -n "$address" ] ; then
    hyprctl --batch -q "dispatch focuswindow address:$address;dispatch alterzorder top"
fi

hyprctl -q dispatch submap reset
