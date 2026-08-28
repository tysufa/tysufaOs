# Eait this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  # 2. Initialize the stable packages for your system architecture
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true; # Necessary if you use proprietary drivers or gaming tools
  };

  zen-base = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;

  zen-with-autoconfig = pkgs.stdenv.mkDerivation {
    pname = "zen-browser-autoconfig";
    version = "custom";

    # Use the completed zen-browser package as our source material
    src = zen-base;
    dontUnpack = true;

    installPhase = ''
      echo "Creating custom Zen package with Sine Mod Manager..."
      mkdir -p $out

      # Copy everything and make writable
      cp -a $src/* $out/
      chmod -R +w $out

      # Dynamically find the folder containing omni.ja
      TARGET_DIR=""
      for dir in $out/lib/zen-* $out/lib/zen-browser $out/lib/zen; do
        if [ -f "$dir/omni.ja" ]; then
          TARGET_DIR="$dir"
          break
        fi
      done

      echo "Injecting Sine bootloader into $TARGET_DIR..."
      mkdir -p "$TARGET_DIR/defaults/pref"

      # Delete the default Nix autoconfig to prevent the mozilla.cfg conflict
      rm -f "$TARGET_DIR/defaults/pref/autoconfig.js"

      # COPY SINE'S FILES INSTEAD OF FX-AUTOCONFIG
      cp ${inputs.sine-src}/program/config.js "$TARGET_DIR/config.js"
      cp ${inputs.sine-src}/program/defaults/pref/config-prefs.js "$TARGET_DIR/defaults/pref/config-prefs.js"

      # Fix hardcoded Nix paths for the launcher
      if [ -d "$out/bin" ]; then
        for file in $out/bin/*; do
          if [ -f "$file" ]; then
            sed -i "s|$src|$out|g" "$file"
          fi
        done
      fi

      if [ -d "$out/share/applications" ]; then
        for file in $out/share/applications/*.desktop; do
          if [ -f "$file" ]; then
            sed -i "s|$src|$out|g" "$file"
          fi
        done
      fi
    '';
  };
  # parllama = pkgs.python3Packages.buildPythonApplication rec {
  #   pname = "parllama";
  #   version = "0.9.2";
  #   format = "pyproject";
  #
  #   src = pkgs.python3Packages.fetchPypi {
  #     inherit pname version;
  #     hash = "sha256-eamgaYnPtkwT899CgVMEmcOcOpCbC82ZN/aAMciU7YE=";
  #   };
  #
  #   doCheck = false;
  #
  #   nativeBuildInputs = with pkgs.python3Packages; [
  #     hatchling # Or setuptools, poetry-core, flit-core depending on pyproject.toml
  #   ];
  #
  #   propagatedBuildInputs = with pkgs.python3Packages; [
  #     setuptools
  #     textual
  #     ollama
  #   ];
  # };
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.noctalia-greeter.nixosModules.default
  ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # fedora bootloader entry (os-prober doesn't find it on my second disk)
  boot.loader.grub.extraEntries = ''
    menuentry "Fedora Linux" {
      insmod part_gpt
      insmod fat
      search --fs-uuid --set=root EADB-E503
      chainloader /EFI/fedora/shimx64.efi
    }
  '';

  # Hide the OS choice for bootloaders.
  # It's still possible to open the bootloader list by pressing any key
  # It will just not appear on screen unless a key is pressed
  # boot.loader.timeout = 0;

  boot = {
    initrd.systemd.enable = true;

    plymouth = {
      enable = true;
      theme = "cuts";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = ["cuts"];
        })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
      "plymouth.use-simpledrm"
    ];
  };

  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    # so that cuda builds faster
    substituters = ["https://cache.nixos-cuda.org"];
    trusted-public-keys = ["cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="];
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ---- GRAPHICS / GAMING ----

  # __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command% to select nivdia gpu

  # this should be enabled automatically by steam even if we remove it
  hardware.graphics.enable = true;

  # nvidia drivers
  services.xserver.videoDrivers = ["nvidia"];

  services.tailscale = {
    enable = true;
  };

  # Fix the nvidia-powerd crash on Lenovo laptops
  systemd.services.nvidia-powerd.enable = false;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true; # Enables deep sleep for the 4080 when not offloading

    prime = {
      # nvidia-offload %command% to activate nvidia gpu when offload mod is on
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # FIX: Wrapped these in quotation marks ""
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  specialisation = {
    gaming-time.configuration = {
      hardware.nvidia = {
        # FIX: Explicitly disable finegrained power management here so Sync mode can build
        powerManagement.finegrained = lib.mkForce false;

        prime.sync.enable = lib.mkForce true;
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };
    };
  };

  hardware.xone.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  programs.gamemode.enable = true;

  # ---- GENERAL SYSTEM OPTIONS ----
  programs.kdeconnect.enable = true;

  networking.hostName = "seven_red_suns"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNS = "1.1.1.1 8.8.8.8";
        Domains = "~spelunky2.net";
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
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

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tysufa = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "tysufa";
    extraGroups = ["networkmanager" "wheel" "adbusers" "kvm"]; #adbusers and kvm are for installing graphene os
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };
  users.extraUsers.tysufa = {
  };

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
      };
      folders = {
        "Test" = {
          path = "/home/tysufa/Documents/dossier_test_syncthing";
          devices = ["server"];
          ignorePerms = false;
        };
        "zen_browser" = {
          path = "/home/tysufa/.config/zen/";
          devices = ["server"];
        };
      };
    };
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = ["qwen2.5:7b" "gemma4:e4b"];
  };

  networking.firewall.allowedTCPPorts = [8384];

  # -------- APPLICATIONS -----------

  # Install firefox.
  programs.firefox.enable = true;

  programs.noctalia-greeter = {
    enable = true;

    # Optional configuration
    greeter-args = "";
    # Full declarative greeter.toml (overwritten on each activation).
    # See examples/greeter.toml for every key (appearance.palette, output, …).
    settings = {
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
        path = "${pkgs.bibata-cursors}/share/icons";
      };
      keyboard = {
        layout = "us";
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # allow non pkgs programs to run with standard library paths
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Core fixes for Archipelago (Kivy/Python)
    mtdev
    libGL
    SDL2 # <--- Fixed the casing here (capitalized)

    # Core fixes for AEXGui (.NET/Avalonia)
    icu
    fontconfig
    freetype
    libice
    libsm

    # Standard X11/Wayland windowing libraries
    libx11
    libxcursor
    libxrandr
    libxi
    libxext
    glib

    # Audio support
    alsa-lib
  ];

  programs.appimage.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true;

  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    # shells
    inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.caelestia-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
    noctalia

    # for Hyprland
    hyprshell

    # hardware/périphériques
    linuxPackages.openrazer

    # -- nvim packages --
    wakatime-cli
    unzip
    stylua # lua formatter
    lua-language-server
    clang-tools # clangd
    tree-sitter
    alejandra # nix formatter
    nixd # nix lsp
    tree-sitter-grammars.tree-sitter-markdown

    # -- gaming packages --
    protonup-qt
    pkgs-stable.lutris
    # bottles
    heroic
    btop
    mangohud
    archipelago
    owmods-gui # outer wilds mod manager
    (olympus.override {celesteWrapper = "steam-run";})
    lumafly # hollow knight mod manager
    poptracker
    r2modman # mod manager, I use it for unfair flips, but it could be used for risk of rain apparently
    protontricks # needed to install bepinex, which is needed to mod tunic
    starsector

    # -- standard desktop apps --
    (pkgs.gimp-with-plugins.override {
      plugins = with pkgs.gimpPlugins; [
        resynthesizer
      ];
    })
    kdePackages.qt6ct
    nwg-look
    adw-gtk3

    nautilus
    vicinae
    proton-vpn
    qbittorrent
    gnome-boxes
    zen-with-autoconfig
    # inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    deezer-desktop
    vesktop
    kitty
    ghostty
    blanket
    libreoffice
    eloquent
    switcheroo
    localsend
    signal-desktop
    thunderbird
    kdePackages.kdeconnect-kde
    discord
    brave
    easyeffects
    piper

    seafile-client
    seadrive-gui

    wtype # reliable text input for handy

    android-tools # for graphene os installation

    # ---- cli/tuis and general apps for development ----
    pkgs.nur.repos.charmbracelet.crush
    gum
    yazi
    zinit

    pkgs.uv
    (pkgs.writeShellScriptBin "parllama" ''
      exec ${pkgs.uv}/bin/uvx parllama "$@"
    '')
    (pkgs.writeShellScriptBin "elia" ''
      exec ${pkgs.uv}/bin/uvx --python 3.12 --from elia-chat elia "$@"
    '')
    (pkgs.writeShellScriptBin "aitui" ''
      exec ${pkgs.uv}/bin/uvx --python 3.12 --with "textual<0.27.0" --from aitui ai "$@"
    '')

    aichat

    ollama-cuda
    opencode
    playerctl
    ddcutil # brightness control
    elogind # allow a popup to show when changing the theme of greeter with noctalia
    wl-clipboard
    typst
    sshfs
    waypipe
    fd
    imagemagick # to show images in neovim
    stow
    wofi
    taskwarrior2
    fastfetch
    croc
    tldr
    ripgrep
    zellij
    bat
    oh-my-posh
    fzf
    zoxide
    eza
    gcc
    rustc
    cargo
    git
    zotero
    (neovim.override {
      withPython3 = true;
      extraPython3Packages = ps:
        with ps; [
          pynvim
          tasklib
          packaging
        ];
    })
    helix
    lazygit
    killall

    os-prober

    # libraries
    libnotify
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"]; # provides autocompletion for pkgs install

  # 76c5dd63-e01a-493d-a127-835292030171
  # ---- MOUNT POINT FOR MY GAMES ----
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/76c5dd63-e01a-493d-a127-835292030171";
    fsType = "btrfs";
    options = ["defaults" "compress=zstd" "nofail"]; # compress=zstd is highly recommended for btrfs gaming
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
