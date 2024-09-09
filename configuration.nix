# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

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
  time.timeZone = "Europe/Paris";

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
    displayManager.sddm.package = pkgs.kdePackages.sddm;
  };


  

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tysufa = {
    isNormalUser = true;
    description = "tysufa";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # enable hyprland
  programs = {
    hyprland.enable = true;
    firefox.enable = true;
    zsh.enable = true; # is also set to true in home manager but is needed to be the shell of the user
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };
  };


  # global theme of my nixos
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes" ];

  environment.sessionVariables = {
    FLAKE = "/home/tysufa/tysufaOs";
    EDITOR = "vim";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wl-clipboard # clipboard for wayland

    walker # highly extensible application launcher
    dmenu-wayland # pass has a dmenu command included

    passff-host # host application for passff on firefox
    pinentry-curses # interface to enter passwords when prompted, necessary for password store
    pass # password store : password manager

    eza # ls but with better presentation
    tree
    
    # sddm themes
    catppuccin-sddm-corners
    (catppuccin-sddm.override {
      flavor = "mocha";
    })

    fzf
    yazi # terminal file manager with lots of customization

    # pour eliot
    uwuify
    uwufetch

    nh #nix helper 

    fastfetch
    ripgrep # dependencie for neovim to grep search on files
    nautilus # file manager
    brightnessctl # to change luminosity on hyprland
    kitty
    neovim
    # inputs.nixpkgsstable.legacyPackages.${pkgs.system}.neovim
    git
    vim
  ];

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
