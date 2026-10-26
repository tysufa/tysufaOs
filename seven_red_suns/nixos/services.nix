{...}: {
  # nvidia drivers
  services.xserver.videoDrivers = ["nvidia"];

  # Fix the nvidia-powerd crash on Lenovo laptops
  systemd.services.nvidia-powerd.enable = false;

  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNS = "1.1.1.1 8.8.8.8";
        Domains = "~spelunky2.net";
      };
    };
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  services.flatpak.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = false;
  services.desktopManager.plasma6.enable = true;

  services.displayManager.noctalia-greeter.enable = true;
  services.displayManager.noctalia-greeter.settings = {
    session.default = "plasma";
  };
  services.displayManager.defaultSession = "plasma"; # this is necessary because of conflicting declarations of this value by niri and plasma

  # Configure keymap in X11
  services.xserver.xkb = {
    extraLayouts.us_qwerty-fr = {
      description = "US QWERTY with French accents";
      languages = [ "fre" "eng" ];
      symbolsFile = ./us_qwerty-fr; # relative path to the downloaded file
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.ratbagd.enable = true; # to make piper work

  services.tailscale.enable = true;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384"; # Listens on all interfaces

    # 1. FIX PERMISSIONS: Force Syncthing to run as your user
    user = "tysufa";
    group = "users";
    dataDir = "/home/tysufa/Documents";
    configDir = "/home/tysufa/.config/syncthing"; # Keeps database out of root-owned paths

    # 2. CORRECT LOCATION: This must be at the top level, not inside 'settings'
    guiPasswordFile = "/etc/syncthing-gui-password";

    settings = {
      gui = {
        user = "tysufa"; # The username you type into the browser login
      };
      devices = {
        "server" = {id = "BIGYUV4-GP4J7MV-XXXD3NU-L6TMQR3-TINI6J4-YRQQFHQ-A3QEJUI-TOOF2Q4";};
        "Pixel8_graphene" = {id = "GMC7GA2-7CTSRK2-QRT776P-JCGWBOK-TPIVV77-7JL32EX-2OXTKF6-OXNIOAJ";};
      };
      folders = {
        "Rusher" = {
          path = "/home/tysufa/Projects/Rusher";
          devices = ["Pixel8_graphene"];
          ignorePatterns = ["!tasks.txt" "*"] ;
        };
      };
    };
  };
}
