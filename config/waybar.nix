{ pkgs, config, ... }:

let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  clock24h = true;
in
{
  # config & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [
          "hyprland/workspaces"
          "cpu"
          "memory"
          "disk"
          # "idle_inhibitor"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "tray"
          "clock"
          "network"
          "backlight"
          "pulseaudio"
          # "custom/hyprbindings"
          # "custom/notification"
          # "custom/exit"
          "battery"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
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
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };
        "tray" = {
          spacing = 12;
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " 󰝟 {format_source}";
          format-source = " {volume}%";
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
    style = 
      ''
        * {
    border: none;
    border-radius: 0;
    font-family: monospace;
    font-weight: bold;
    font-size: 14px;
    min-height: 0;
}

window#waybar {
    background: rgba(21, 18, 27, 0);
    color: #cdd6f4;
}

tooltip {
    background: #1e1e2e;
    border-radius: 10px;
    border-width: 2px;
    border-style: solid;
    border-color: #11111b;
}

#workspaces button {
    padding: 5px;
    color: #313244;
    margin-right: 5px;
}

#workspaces button.active {
    color: #a6adc8;
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

#custom-language,
#custom-updates,
#custom-caffeine,
#window,
#clock,
#battery,
#pulseaudio,
#network,
#workspaces,
#tray,
#backlight {
    background: #1e1e2e;
    padding: 0px 10px;
    margin: 3px 0px;
    margin-top: 10px;
    border: 1px solid #181825;
}

#tray {
    border-radius: 10px;
    margin-right: 10px;
}

#workspaces {
    background: #1e1e2e;
    border-radius: 10px;
    margin-left: 10px;
    padding-right: 0px;
    padding-left: 5px;
}

#custom-caffeine {
    color: #89dceb;
    border-radius: 10px 0px 0px 10px;
    border-right: 0px;
    margin-left: 10px;
}

#custom-language {
    color: #f38ba8;
    border-left: 0px;
    border-right: 0px;
}

#custom-updates {
    color: #f5c2e7;
    border-left: 0px;
    border-right: 0px;
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
}

#network {
    color: #fab387;
    border-left: 0px;
    border-right: 0px;
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
  };
}
