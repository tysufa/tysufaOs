# Eait this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    ./nixos/programs.nix
    ./nixos/services.nix
    ./nixos/hardware.nix
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

  # ---- GENERAL SYSTEM OPTIONS ----
  networking.hostName = "seven_red_suns"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  networking.firewall.allowedTCPPorts = [8384];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # allow non pkgs programs to run with standard library paths
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

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };

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
