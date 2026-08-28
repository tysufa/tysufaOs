{
  pkgs,
  inputs,
  ...
}: let
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true; # Necessary if you use proprietary drivers or gaming tools
  };

  zen-base = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;

  zen-sine = pkgs.stdenv.mkDerivation {
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
in {
  programs.kdeconnect.enable = true;

  programs.zsh.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  programs.gamemode.enable = true;

  programs.firefox.enable = true;

  programs.hyprland.enable = true;

  programs.appimage.enable = true;
  programs.nix-ld.enable = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = ["qwen2.5:7b" "gemma4:e4b"];
  };

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
    zathura
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
    zen-sine
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
}
