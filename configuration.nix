{ pkgs, inputs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable "Silent Boot"
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/Paris";
  time.timeZone = "Asia/Taipei";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

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

  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      displayManager.gdm.enable = false;
      # Enable the GNOME Desktop Environment.
      desktopManager.gnome.enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "fr";
        variant = "";
      };
    };

    displayManager.sddm.enable = true;
    # services.xserver.displayManager.sddm.theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
    displayManager.sddm.theme = "catppuccin-mocha";
    displayManager.sddm.package = pkgs.kdePackages.sddm; # to use catppuccin theme
  };

  # Configure console keymap
  console.keyMap = "fr";

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
  };

  fonts.packages = with pkgs; [
    # (nerdfonts.override {fonts = ["JetBrainsMono"];})
    nerd-fonts.jetbrains-mono
  ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tysufa = {
    isNormalUser = true;
    description = "tysufa";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    shell = pkgs.zsh; 
  };

  virtualisation.containers.enable = true;
  virtualisation.docker.enable = true; # install docker
  virtualisation.podman.enable = true;

  # enable hyprland
  programs = {
    hyprland.enable = true;
    firefox.enable = true;
    zsh.enable = true; # is also set to true in home manager but is needed to be the shell of the user
    gnupg.agent = { 
      enable = true; # enable gpg
      pinentryPackage = pkgs.pinentry-curses; # a pinentry is th window poping when asking for a password
      enableSSHSupport = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };

  hardware.graphics.enable32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # global theme of my nixos
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes" ];

  environment.sessionVariables = {
    FLAKE = "/home/tysufa/tysufaOs";
    EDITOR = "vim";
  };

    

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    yad # allow you to display gtk dialog boxes from command line
    gitmux

    libreoffice-qt
    hunspell # for spellcheck
    hunspellDicts.fr-any

    playerctl # used for waybar to play show music
    
    spotify
    discord
    floorp
    inputs.zen-browser.packages."${system}".default
    vivaldi
    mullvad-browser
    qbittorrent

    lunatask

    vscode

    R
    ocaml
    gcc
    clang
    gdb
    cmake
    gnumake # apparently make is included in cmake but I leave it there just because it makes it clearer

    (python311.withPackages(ps: with ps; [
      # required for calculate extension of ulauncher
      # requests
      # pint
      # parsedatetime
    ]))

    go
    cobra-cli # Cobra CLI tool to generate applications and commands, cobra is a go module to make cli apps

    tldr # ls but with better presentation
    eza # ls but with better presentation
    zoxide # better cd
    tree
    bat
    acpi # get battery level
    figlet
    btop
    killall
    fzf
    yazi # terminal file manager with lots of customization
    cool-retro-term
    pipes

    albert
    ulauncher

    wl-clipboard # clipboard for wayland
    hyprpicker # selectionneur de couleur
    hyprshot # screenshot
    #dependencies of hyprshot
    grim
    slurp
    libnotify
    dunst
    swww #wallpaper manager

    walker # highly extensible application launcher
    dmenu-wayland # pass has a dmenu command included

    passff-host # host application for passff on firefox
    pinentry-curses # interface to enter passwords when prompted, necessary for password store
    pass # password store : password manager

    
    # sddm themes
    catppuccin-sddm-corners
    (catppuccin-sddm.override {
      flavor = "mocha";
    })


    nh #nix helper 

    # wakatime-cli # dependency for wakatime plugin in neovim
    ripgrep # dependency for neovim to grep search on files
    nautilus # file manager
    brightnessctl # to change luminosity on hyprland
    
    kitty
    alacritty
    ghostty
    zed-editor
    neovim
    # inputs.nixpkgsstable.legacyPackages.${pkgs.system}.neovim
    git
    vim
    unzip
    wget

    # network communication class
    traceroute
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
