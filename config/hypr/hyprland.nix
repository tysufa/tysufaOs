{ pkgs, ... }:

{
  stylix.targets.hyprland.enable = false;
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig =
      let 
        modifier = "SUPER";
        # BG = ~/tysufaOs/backgrounds/ -name "*.jpg" -o -name "*.png" | shuf -n1
      in
        ''
          
          exec-once = sleep 1.5; swww-daemon
          exec-once = pkill waybar; waybar
          # exec-once = change_wallpaper.sh
          # exec-once = killall -q swaync;sleep .5 && swaync
          # exec-once = dbus-update-activation-environment --systemd --all
          monitor=,preferred,auto,1
          general {
            gaps_in = 2
            gaps_out = 3
            border_size = 2
            layout = dwindle
            resize_on_border = true
          }
          input {
            kb_layout = us,fr
            kb_options = grp:alt_space_toggle,caps:escape
            follow_mouse = 1
            touchpad {
              natural_scroll = false
            }
            sensitivity = 1.0 # -1.0 - 1.0, 0 means no modification.
            accel_profile = flat
          }
          windowrule = center,^(class:steam)$
          windowrule = float, title:(rofi*)
          windowrule = noborder, title:(rofi*)
          windowrule = center, title:(rofi*)
          windowrulev2 = stayfocused,class:^(ulauncher)$ # keep ulauncher focused
          windowrulev2 = stayfocused,class:^(albert)$ # keep albert focused
          windowrulev2 = stayfocused, title:^()$,class:^(steam)$
          windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$
          windowrulev2 = opacity 0.9 0.7, class:^(Brave)$
          windowrulev2 = opacity 0.9 0.7, class:^(thunar)$
          gestures {
            workspace_swipe = true
            workspace_swipe_fingers = 3
          }
          misc {
            initial_workspace_tracking = 0
            mouse_move_enables_dpms = true
            key_press_enables_dpms = false
          }
          animations {
            enabled = yes
            bezier = wind, 0.05, 0.9, 0.1, 1.05
            bezier = winIn, 0.1, 1.1, 0.1, 1.1
            bezier = winOut, 0.3, -0.3, 0, 1
            bezier = liner, 1, 1, 1, 1
            animation = windows, 1, 6, wind, slide
            animation = windowsIn, 1, 6, winIn, slide
            animation = windowsOut, 1, 5, winOut, slide
            animation = windowsMove, 1, 5, wind, slide
            animation = border, 1, 1, liner
            animation = fade, 1, 10, default
            animation = workspaces, 1, 5, wind
          }
          decoration {
            rounding = 10
            shadow:enabled = true
            shadow:range = 4
            shadow:render_power = 3
            shadow:color = rgba(1a1a1aee)
            blur {
                enabled = true
                size = 5
                passes = 3
                new_optimizations = on
                ignore_opacity = off
            }
          }
          plugin {
            hyprtrails {
            }
          }
          dwindle {
            pseudotile = true
            preserve_split = true
          }
          bind = ${modifier},Return,exec,kitty
          bind = ${modifier},D,exec,kitty
          bind = ${modifier}SHIFT,D,exec,cool-retro-term
          bind = ${modifier}SHIFT,Return,exec,rofi -show drun
          bind = ${modifier},R, exec , albert toggle || albert

          bind = ${modifier}ALT ,F,exec,web-search
          bind = ${modifier}ALT,W,exec,wallsetter
          bind = ${modifier}SHIFT,N,exec,swaync-client -rs
          bind = ${modifier}SHIFT,E,exec,emopicker9000
          bind = ${modifier}SHIFT,I,togglesplit,

          # windowrulv2 = float, title:^(lnks)$
          bind = ${modifier},B,exec, [float;noanim] kitty -e ~/tysufaOs/config/scripts/lnks/lnks.sh 
          bind = ${modifier}SHIFT,B,exec, [float;noanim] kitty -e ~/tysufaOs/config/scripts/lnks/lnks.sh -e 
          bind = ${modifier},F,exec,firefox
          bind = ${modifier},C,exec,hyprpicker -a
          bind = ${modifier}SHIFT,S,exec,grim -g "$(slurp)" - | wl-copy && notify-send "screenshot copied"
          bind = ${modifier},E,exec,nautilus
          bind = ${modifier},S,exec,spotify
          bind = ${modifier},Q,killactive,
          bind = ${modifier},P,pseudo,
          bind = ${modifier}SHIFT,F,fullscreen,
          bind = ${modifier},V,togglefloating,
          bind = ${modifier}SHIFT,L,exec,hyprlock
          bind = ${modifier}SHIFT,U,exec,systemctl suspend && hyprlock
          bind = ${modifier},M,exec,wlogout
          bind = ${modifier}SHIFT,M,exit,
          bind = ${modifier}SHIFT,left,movewindow,l
          bind = ${modifier}SHIFT,right,movewindow,r
          bind = ${modifier}SHIFT,up,movewindow,u
          bind = ${modifier}SHIFT,down,movewindow,d
          bind = ${modifier}SHIFT,h,movewindow,l
          bind = ${modifier}SHIFT,l,movewindow,r
          bind = ${modifier}SHIFT,k,movewindow,u
          bind = ${modifier}SHIFT,j,movewindow,d
          bind = ${modifier}SHIFT,r,exec, nh home switch ~/tysufaOs
          bind = ${modifier},left,movefocus,l
          bind = ${modifier},right,movefocus,r
          bind = ${modifier},up,movefocus,u
          bind = ${modifier},down,movefocus,d
          bind = ${modifier},h,movefocus,l
          bind = ${modifier},l,movefocus,r
          bind = ${modifier},k,movefocus,u
          bind = ${modifier},j,movefocus,d
          bind = ${modifier},code:10,workspace,1
          bind = ${modifier},code:11,workspace,2
          bind = ${modifier},code:12,workspace,3
          bind = ${modifier},code:13,workspace,4
          bind = ${modifier},code:14,workspace,5
          bind = ${modifier},code:15,workspace,6
          bind = ${modifier},code:16,workspace,7
          bind = ${modifier},code:17,workspace,8
          bind = ${modifier},code:18,workspace,9
          bind = ${modifier},code:19,workspace,10
          bind = ${modifier}SHIFT,SPACE,movetoworkspace,special
          bind = ${modifier},SPACE,togglespecialworkspace
          bind = ${modifier}SHIFT,code:10,movetoworkspace,1
          bind = ${modifier}SHIFT,code:11,movetoworkspace,2
          bind = ${modifier}SHIFT,code:12,movetoworkspace,3
          bind = ${modifier}SHIFT,code:13,movetoworkspace,4
          bind = ${modifier}SHIFT,code:14,movetoworkspace,5
          bind = ${modifier}SHIFT,code:15,movetoworkspace,6
          bind = ${modifier}SHIFT,code:16,movetoworkspace,7
          bind = ${modifier}SHIFT,code:17,movetoworkspace,8
          bind = ${modifier}SHIFT,code:18,movetoworkspace,9
          bind = ${modifier}SHIFT,code:19,movetoworkspace,10
          bind = ${modifier}CONTROL,right,workspace,e+1
          bind = ${modifier}CONTROL,left,workspace,e-1
          bind = ${modifier},mouse_down,workspace, e+1
          bind = ${modifier},mouse_up,workspace, e-1
          bindm = ${modifier},mouse:272,movewindow
          bindm = ${modifier},mouse:273,resizewindow
          bind = ALT,Tab,cyclenext
          bind = ALT,Tab,bringactivetotop
          bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          bind = ,XF86AudioPlay, exec, playerctl play-pause
          bind = ,XF86AudioPause, exec, playerctl play-pause
          bind = ,XF86AudioNext, exec, playerctl next
          bind = ,XF86AudioPrev, exec, playerctl previous
          bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
          bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
          bind = ${modifier},W,exec,pkill waybar || waybar
      '';
  };
}
