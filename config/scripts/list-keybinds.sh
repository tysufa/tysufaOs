cat ~/tysufaOs/config/hypr/hyprland.nix | grep "bind*" | grep "SHIFT" -v | grep "code" -v | sed s/"bind = "// | sed s/"\${modifier}"/"super "/ | tr ',' '+ '
