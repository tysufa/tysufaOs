{ config, pkgs, ... }:

{
  home.username = "tysufa";
  home.homeDirectory = "/home/tysufa";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  stylix.enable = true;
  stylix.image = ./backgrounds/wallpaper-theme-converter.png;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  imports = [
    ./config/hypr/hyprland.nix
    ./config/waybar.nix
    ./config/neovim.nix
    ./config/ohmyposh.nix
    ./config/rofi.nix
    ./config/zsh.nix
    ./config/hyprlock.nix
  ];

  programs.kitty = {
      enable = true;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
        font_size = 16;
        font = "JetBrainsMono Nerd Font";
        font_family = "JetBrainsMono Nerd Font";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        disable_ligatures = "never";
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
      '';
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy. ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  
  programs = {
    git = {
      enable = true;
      userEmail = "philemon.penot@gmail.com";
      userName = "tysufa";
    };
    fuzzel.enable = true;
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    hyprlock.enable = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
    '';
    initExtra = ''
        fastfetch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
    '';
    shellAliases = {
      sv = "sudo nvim";
      # fr = "nh os switch --hostname nixos /home/tysufa/zaneyos";
      # fu = "nh os switch --hostname nixos --update /home/tysufa/zaneyos";
      # zu = "sh <(curl -L https://gitlab.com/Zaney/zaneyos/-/raw/main/install-zaneyos.sh)";
      # ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      v = "nvim";
      cat = "bat";
      ls = "eza --icons";
      ll = "eza -lh --icons --grid --group-directories-first";
      la = "eza -lah --icons --grid --group-directories-first";
      h = "cd /home/tysufa";
      gs = "git status";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit -m";
      gp = "pass -c programmation/github && git push";
      gt = "pass -c programmation/github";
      glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };

}
