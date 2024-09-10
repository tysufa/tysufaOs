{
  programs.waybar.settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [
          "hyprland/workspaces"
          # "cpu"
          # "memory"
          # "disk"
          # "idle_inhibitor"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "pulseaudio" "backlight" "battery" "clock" "tray" "custom/lock" "custom/power" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            default = "";
            active = "";
            urgent = "";
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
}

window.bottom_bar#waybar {
  background-color: alpha(@base, 0.7);
  border-top: solid alpha(@surface1, 0.7) 2;
}

window.top_bar#waybar {
  background-color: alpha(@base, 0.7);
  border-bottom: solid alpha(@surface1, 0.7) 2;
}

window.left_bar#waybar {
  background-color: alpha(@base, 0.7);
  border-top: solid alpha(@surface1, 0.7) 2;
  border-right: solid alpha(@surface1, 0.7) 2;
  border-bottom: solid alpha(@surface1, 0.7) 2;
  border-radius: 0 15 15 0;
}

window.bottom_bar .modules-center {
  background-color: alpha(@surface1, 0.7);
  color: @green;
  border-radius: 15;
  padding-left: 20;
  padding-right: 20;
  margin-top: 5;
  margin-bottom: 5;
}

window.bottom_bar .modules-left {
  background-color: alpha(@surface1, 0.7);
  border-radius: 0 15 15 0;
  padding-left: 20;
  padding-right: 20;
  margin-top: 5;
  margin-bottom: 5;
}

window.bottom_bar .modules-right {
  background-color: alpha(@surface1, 0.7);
  border-radius: 15 0 0 15;
  padding-left: 20;
  padding-right: 20;
  margin-top: 5;
  margin-bottom: 5;
}



#user {
  padding-left: 10;
}

#language {
  padding-left: 15;
}

#keyboard-state label.locked {
  color: @yellow;
}

#keyboard-state label {
  color: @subtext0;
}

#workspaces {
  margin-left: 10;
}

#workspaces button {
  color: @text;
  font-size: 1.25rem;
}

#workspaces button.empty {
  color: @overlay0;
}

#workspaces button.active {
  color: @peach;
}


#submap {
  background-color: alpha(@surface1, 0.7);
  border-radius: 15;
  padding-left: 15;
  padding-right: 15;
  margin-left: 20;
  margin-right: 20;
  margin-top: 5;
  margin-bottom: 5;
}

window.top_bar .modules-center {
  font-weight: bold;
  background-color: alpha(@surface1, 0.7);
  color: @peach;
  border-radius: 15;
  padding-left: 20;
  padding-right: 20;
  margin-top: 5;
  margin-bottom: 5;
}

#custom-separator {
  color: @green;
}

#custom-separator_dot {
  color: @green;
}

#clock.time {
  color: @flamingo;
}

#clock.week {
  color: @sapphire;
}

#clock.month {
  color: @sapphire;
}

#clock.calendar {
  color: @mauve;
}

#bluetooth {
  background-color: alpha(@surface1, 0.7);
  border-radius: 15;
  padding-left: 15;
  padding-right: 15;
  margin-top: 5;
  margin-bottom: 5;
}

#bluetooth.disabled {
  background-color: alpha(@surface0, 0.7);
  color: @subtext0;
}

#bluetooth.on {
  color: @blue;
}

#bluetooth.connected {
  color: @sapphire;
}

#network {
  background-color: alpha(@surface1, 0.7);
  border-radius: 15;
  padding-left: 15;
  padding-right: 15;
  margin-left: 2;
  margin-right: 2;
  margin-top: 5;
  margin-bottom: 5;
}

#network.disabled {
  background-color: alpha(@surface0, 0.7);
  color: @subtext0;
}

#network.disconnected {
  color: @red;
}

#network.wifi {
  color: @teal;
}

#idle_inhibitor {
  margin-right: 2;
}

#idle_inhibitor.deactivated {
  color: @subtext0;
}

#custom-dunst.off {
  color: @subtext0;
}

#custom-airplane_mode {
  margin-right: 2;
}

#custom-airplane_mode.off {
  color: @subtext0;
}

#custom-night_mode {
  margin-right: 2;
}

#custom-night_mode.off {
  color: @subtext0;
}

#custom-dunst {
  margin-right: 2;
}

#custom-media.Paused {
  color: @subtext0;
}

#custom-webcam {
  color: @maroon;
  margin-right: 3;
}

#privacy-item.screenshare {
  color: @peach;
  margin-right: 5;
}

#privacy-item.audio-in {
  color: @pink;
  margin-right: 4;
}

#custom-recording {
  color: @red;
  margin-right: 4;
}

#custom-geo {
  color: @yellow;
  margin-right: 4;
}

#custom-logout_menu {
  color: @red;
  background-color: alpha(@surface1, 0.7);
  border-radius: 15 0 0 15;
  padding-left: 10;
  padding-right: 5;
  margin-top: 5;
  margin-bottom: 5;
}

window.left_bar .modules-center {
  background-color: alpha(@surface1, 0.7);
  border-radius: 0 15 15 0;
  margin-right: 5;
  margin-top: 15;
  margin-bottom: 15;
  padding-top: 5;
  padding-bottom: 5;
}

#taskbar {
  margin-top: 10;
  margin-right: 10;
  margin-left: 10;
}

#taskbar button.active {
  background-color: alpha(@surface1, 0.7);
  border-radius: 10;
}

#tray {
  margin-bottom: 10;
  margin-right: 10;
  margin-left: 10;
}

#tray>.needs-attention {
  background-color: alpha(@maroon, 0.7);
  border-radius: 10;
}

#cpu {
  color: @sapphire;
}

#cpu.low {
  color: @rosewater;
}

#cpu.lower-medium {
  color: @yellow;
}

#cpu.medium {
  color: @peach;
}

#cpu.upper-medium {
  color: @maroon;
}

#cpu.high {
  color: @red;
}

#memory {
  color: @sapphire;
}

#memory.low {
  color: @rosewater;
}

#memory.lower-medium {
  color: @yellow;
}

#memory.medium {
  color: @peach;
}

#memory.upper-medium {
  color: @maroon;
}

#memory.high {
  color: @red;
}

#disk {
  color: @sapphire;
}

#disk.low {
  color: @rosewater;
}

#disk.lower-medium {
  color: @yellow;
}

#disk.medium {
  color: @peach;
}

#disk.upper-medium {
  color: @maroon;
}

#disk.high {
  color: @red;
}

#temperature {
  color: @green;
}

#temperature.critical {
  color: @red;
}

#battery {
  color: @teal;
}

#battery.low {
  color: @red;
}

#battery.lower-medium {
  color: @maroon;
}

#battery.medium {
  color: @peach;
}

#battery.upper-medium {
  color: @flamingo;
}

#battery.high {
  color: @rosewater;
}

#backlight {
  color: @overlay0;
}

#backlight.low {
  color: @overlay1;
}

#backlight.lower-medium {
  color: @overlay2;
}

#backlight.medium {
  color: @subtext0;
}

#backlight.upper-medium {
  color: @subtext1;
}

#backlight.high {
  color: @text;
}

#pulseaudio.bluetooth {
  color: @sapphire;
}

#pulseaudio.muted {
  color: @surface2;
}

#pulseaudio {
  color: @text;
}

#pulseaudio.low {
  color: @overlay0;
}

#pulseaudio.lower-medium {
  color: @overlay1;
}

#pulseaudio.medium {
  color: @overlay2;
}

#pulseaudio.upper-medium {
  color: @subtext0;
}

#pulseaudio.high {
  color: @subtext1;
}

#systemd-failed-units {
  color: @red;
}     
    '';

}
