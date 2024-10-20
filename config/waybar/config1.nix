{
  programs.waybar.settings = [
    {
      layer = "top";
      position = "top";
      modules-left = [
        "hyprland/workspaces"
        "clock"
        # "cpu"
        # "memory"
      ];
      modules-center = [ "custom/music" "custom/wallpaper"];
      modules-right = [
        "tray"
        "network"
        "backlight"
        "pulseaudio"
        "battery"
        # "custom/hyprbindings"
        # "custom/notification"
        # "custom/exit"
      ];
      "custom/wallpaper" = {
        "tooltip" = false;
        "format" = "󰸉 ";
        "on-click" = "sh ~/tysufaOs/config/scripts/change_wallpaper.sh";
      };

      "custom/music" = {
        "format"= "{}";
        "format-icons" = {
          "Playing" = " ";
          "Paused" = " ";
        };
        "escape"= true;
        "interval"= 5;
        "tooltip" = false;
        "exec" = "playerctl metadata --format='{{ title }}'";
        "on-click" = "playerctl play-pause";
        "on-scroll-up" = "playerctl -p spotify next";
        "on-scroll-down" = "playerctl -p spotify previous";
    };
      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{icon}";
        format-icons = {
          default = "";
          active = "";
          urgent = "";
        };
        persistent_workspaces = {
            "1"= [];
            "2"= [];
            "3"= [];
            "4"= [];
            "5"= [];
            "6"= [];
            "7"= [];
            "8"= [];
            "9"= [];
            "10"= [];
        };
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
      };
      "clock" = {
        format = '' {:L%H:%M  %d/%m}'';
        # format = ''{: L%H:%M   %d/%m}'';
        tooltip = false;
        tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
      };
      "hyprland/window" = {
        max-length = 22;
        separate-outputs = false;
        rewrite = {
          "" = "No Windows";
        };
      };
      "memory" = {
        interval = 5;
        format = " {}%";
        tooltip = true;
      };
      "cpu" = {
        interval = 5;
        format = " {usage:2}%";
        tooltip = true;
      };
      "disk" = {
        format = " {free}";
        tooltip = true;
      };
      "network" = {
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        format-ethernet = " {bandwidthDownOctets}";
        format-wifi = "{icon}";
        format-disconnected = "󰤮";
        tooltip-format-wifi = "Signal Strenght: {signalStrength}% | Down Speed: {bandwidthDownBits}, Up Speed: {bandwidthUpBits}";
      };
      "backlight" = {
        "device"= "intel_backlight";
          "format"= "{icon} {percent}%";
          "format-icons"= ["" "" "" "" "" "" "" "" ""];
          "on-scroll-up"= "brightnessctl set 1%+";
          "on-scroll-down"= "brightnessctl set 1%-";
          "min-length"= 6;
      };
        "tray" = {
          spacing = 12;
        };
      "pulseaudio" = {
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " 󰝟 {format_source}";
        # format-source = " {volume}%";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
            ""
          ];
        };
        on-click = "sleep 0.1 && pavucontrol";
      };
      "custom/exit" = {
        tooltip = false;
        format = "";
        on-click = "sleep 0.1 && wlogout";
      };
      "custom/startmenu" = {
        tooltip = false;
        format = "";
        # exec = "rofi -show drun";
        on-click = "sleep 0.1 && rofi -show drun";
      };
      "custom/hyprbindings" = {
        tooltip = false;
        format = "󱕴";
        on-click = "sleep 0.1 && list-hypr-bindings";
      };
      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
        tooltip = "true";
      };
      "custom/notification" = {
        tooltip = false;
        format = "{icon} {}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "sleep 0.1 && task-waybar";
        escape = true;
      };
      "battery" = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󱘖 {capacity}%";
        format-icons = [
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
        on-click = "";
        tooltip = false;
      };
    }
    ];
  
  programs.waybar.style = 
    ''
@define-color base   #1e1e2e;
@define-color mantle #181825;
@define-color crust  #11111b;

@define-color text     #cdd6f4;
@define-color subtext0 #a6adc8;
@define-color subtext1 #bac2de;

@define-color surface0 #313244;
@define-color surface1 #45475a;
@define-color surface2 #585b70;

@define-color overlay0 #6c7086;
@define-color overlay1 #7f849c;
@define-color overlay2 #9399b2;

@define-color blue      #89b4fa;
@define-color lavender  #b4befe;
@define-color sapphire  #74c7ec;
@define-color sky       #89dceb;
@define-color teal      #94e2d5;
@define-color green     #a6e3a1;
@define-color yellow    #f9e2af;
@define-color peach     #fab387;
@define-color maroon    #eba0ac;
@define-color red       #f38ba8;
@define-color mauve     #cba6f7;
@define-color pink      #f5c2e7;
@define-color flamingo  #f2cdcd;
@define-color rosewater #f5e0dc;

        * {
    border: none;
    border-radius: 0;
    font-family: monospace;
    font-weight: bold;
    font-size: 17px;
    min-height: 0;
}

window#waybar {
    background: rgba(21, 18, 27, 0);
    color: @text;
}

tooltip {
    background: @base;
    border-radius: 10px;
    border-width: 2px;
    border-style: solid;
    border-color: @crust;
}
/*
#workspaces button {
    padding: 5px;
    color: @surface0;
    margin-right: 5px;
}

#workspaces button.active {
    color: @peach;
}

#workspaces button.focused {
    color: #a6adc8;
    background: #eba0ac;
    border-radius: 10px;
}

#workspaces button.urgent {
    color: #11111b;
    background: #a6e3a1;
    border-radius: 10px;
}

#workspaces button:hover {
    background: #11111b;
    color: #cdd6f4;
    border-radius: 10px;
}
*/

#workspaces {
    background: @crust;
    margin: 2px 1px 3px 1px;
    padding: 0px 1px;
    border-radius: 15px;
    border: 0px;
    font-weight: bold;
    font-style: normal;
    opacity: 1;
    font-size: 6px;
    color: @crust;
}

#workspaces button {
    padding: 0px 5px;
    margin: 5px 3px;
    border-radius: 15px;
    border: 0px;
    color: @text;
    background-color: @lavender;
    transition: all 0.3s ease-in-out;
    opacity: 1;
}

#workspaces button.active {
    color: @text;
    background: @blue;
    border-radius: 15px;
    min-width: 40px;
    transition: all 0.3s ease-in-out;
    opacity:1.0;
}

#workspaces button:hover {
    color: @text;
    background: @peach;
    border-radius: 15px;
    opacity:1;
}

#custom-language,
#custom-updates,
#custom-caffeine,
#custom-music,
#custom-wallpaper,
#window,
#clock,
#battery,
#pulseaudio,
#workspaces,
#network,
#tray,
#backlight {
    background: @base;
    padding: 0px 10px;
    margin: 3px 0px;
    margin-top: 10px;
    border: 1px solid #181825;
}

#custom-wallpaper {
  color: @red;
}

#custom-wallpaper,
#tray {
    border-radius: 10px;
    margin-right: 10px;
    margin-left: 10px;
}

#workspaces {
    background: @base;
    border-radius: 10px;
    margin-left: 10px;
    padding-right: 0px;
    padding-left: 5px;
}

#window {
    border-radius: 10px;
    margin-left: 60px;
    margin-right: 60px;
}

#clock {
    color: #f9e2af;
    border-radius: 10px;
    margin-left: 10px;
    margin-right: 10px;
}

#network {
    color: #fab387;
    border-left: 0px;
    border-right: 0px;
    border-radius: 10px 0 0 10px;
}

#pulseaudio {
    color: #89b4fa;
    border-left: 0px;
    border-right: 0px;
}

#battery {
    color: #a6e3a1;
    border-radius: 0 10px 10px 0;
    margin-right: 10px;
    border-left: 0px;
}

#backlight {
    color: #cba6f7;
    border-left: 0px;
    border-right: 0px;
}
      '';

}
