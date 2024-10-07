{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label  = "lock";
        action  = "hyprlock";
        text  = "Lock";
        keybind  = "l";
      }
      {
        label  = "reboot";
        action  = "systemctl reboot";
        text  = "Reboot";
        keybind  = "r";
      }
      {
        label = "shutdown";
        action  = "systemctl poweroff";
        text  = "Shutdown";
        keybind  = "s";
      }
      {
        label = "logout";
        action  = "hyprctl dispatch exit 0";
        text  = "Logout";
        keybind  = "e";
      }
      {
        label  = "suspend";
        action  = "systemctl suspend";
        text  = "Suspend";
        keybind  = "u";
      }
    ];
  style = ''
    window {
    font-family: CaskaydiaCove Nerd Font, monospace;
    font-size: 12pt;
    color: #cdd6f4; 
    background-color: rgba(0, 0, 0, .9);
}

button {
    background-repeat: no-repeat;
    background-position: center;
    background-size: 25%;
    border: none;
    color: #fbf1c7;
    text-shadow: none;
    border-radius: 20px 20px 20px 20px;
    background-color: rgba(1, 121, 111, 0);
    margin: 5px;
    transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
}

#lock {
    background-image: image(url("/home/tysufa/tysufaOs/config/wlogout/lock.png"));
}
/*
#lock:focus {
    background-image: image(url("/home/tysufa/tysufaOs/config/wlogout/lock-hover.png"));
}
*/
#logout {
    background-image: image(url("/home/tysufa/tysufaOs/config/wlogout/logout.png"));
}
#logout:focus {
    background-image: image(url("/home/tysufa/tysufaOs/config/wlogout/logout-hover.png"));
}

#suspend {
    background-image: image(url("/home/tysufa/tysufaOs/config/wlogout/sleep.png"));
} 
#suspend:focus {
    background-image: image(url("/home/tysufa/tysufaOs/config/wlogout/sleep-hover.png"));
}

#shutdown {
    background-image: image(url("/home/tysufa/tysufaOs/config/wlogout/power.png"));
}
#shutdown:focus {
    background-image: image(url("/home/tysufa/tysufaOs/config/wlogout/power-hover.png"));
}

#reboot {
    background-image: image(url("/home/tysufa/tysufaOs/config/wlogout/restart.png"));
}
#reboot:focus {
    background-image: image(url("/home/tysufa/tysufaOs/config/wlogout/restart-hover.png"));
}
    '';
  };
  
}
