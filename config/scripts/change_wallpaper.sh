BG=$(find ~/tysufaOs/backgrounds/ -name "*.jpg" -o -name "*.png" | shuf -n1)

pgrep swww-daemon >/dev/null || swww-daemon

swww img "$BG" \
  --transition-fps 60 \
  --transition-duration 2 \
  --transition-type wipe \
  --transition-pos top-right \
  --transition-bezier .3,0,0,.99 \
  --transition-angle 135 || true
