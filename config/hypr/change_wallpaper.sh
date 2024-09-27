while true; do
  BG=$(find ~/tysufaOs/backgrounds/ -name "*.jpg" -o -name "*.png" | shuf -n1)
  if pgrep swww-daemon >/dev/null; then
    swww img "$BG" \
      --transition-fps 60 \
      --transition-duration 2 \
      --transition-type wipe \
      --transition-pos top-right \
      --transition-bezier .3,0,0,.99 \
      --transition-angle 135 || true
  else
    (swww-daemon 1>/dev/null 2>/dev/null &) || true
  fi
  sleep 5
done
