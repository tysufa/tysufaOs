{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    history.size = 10000;
    history.path = "/home/tysufa/zsh/history";
    initExtra = ''
        setopt hist_ignore_space

        bindkey -e
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward

        # preview directory's content with eza when completing cd
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
        zstyle ':fzf-tab:complete:ls:*' fzf-preview 'cat $realpath'
        zstyle ':completion:*' menu no
    '';
    shellAliases = {
      sv = "sudo nvim";
      # fr = "nh os switch --hostname tysufa /home/tysufa/zaneyos";
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
    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];
  };
}