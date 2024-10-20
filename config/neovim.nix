{ pkgs, lib,... }:
let
  cellular-automaton = pkgs.vimUtils.buildVimPlugin {
    name = "cellular-automaton";
    src = pkgs.fetchFromGitHub {
      owner = "Eandrju";
      repo = "cellular-automaton.nvim";
      rev = "11aea08aa084f9d523b0142c2cd9441b8ede09ed";
      hash = "sha256-nIv7ISRk0+yWd1lGEwAV6u1U7EFQj/T9F8pU6O0Wf0s=";
    };
  };
in

{
  # xdg.configFile."nvim".source = ./../nvimtmp;
  stylix.targets.neovim.enable = false;
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      # vimAlias = true; vimdiffAlias = true;
      withNodeJs = true;
      extraPackages = with pkgs; [
        typescript-language-server # for js
        ocamlPackages.ocaml-lsp
        clang-tools
        lua-language-server
        gopls
        wl-clipboard
        luajitPackages.lua-lsp
        luajitPackages.jsregexp
        nil
        rust-analyzer
        nodePackages.bash-language-server
        yaml-language-server
        pyright
        marksman
      ];
      plugins = with pkgs.vimPlugins; [
        catppuccin-nvim
        alpha-nvim # pretty startup screen

        vim-floaterm # floating terminal
        mini-nvim # dependencie for render-markdown
        render-markdown-nvim
        fidget-nvim
        cmp-path
        nvim-notify
        noice-nvim
        which-key-nvim
        harpoon
        undotree
        oil-nvim
        colorizer
        startup-nvim
        bufferline-nvim
        dressing-nvim # improve ui
        nui-nvim # ui component plugins (a dependencie)
        (nvim-treesitter.withPlugins (treesitter-plugins:
          with treesitter-plugins; [
            bash
            c
            cpp
            lua
            nix
            python
            zig
            go
            ocaml
          ]))
        lualine-nvim
        nvim-autopairs
        nvim-web-devicons
        nvim-cmp
        nvim-lspconfig
        cmp-nvim-lsp
        luasnip
        cmp_luasnip
        friendly-snippets
        lspkind-nvim # add pictograms to neovim built in lsp 
        comment-nvim
        plenary-nvim # collection of neovim functions, a dependencie
        neodev-nvim # TODO: replace neodev by lazydev since it's more recent and neodev got archived
        telescope-nvim
        todo-comments-nvim
        nvim-tree-lua
        telescope-fzf-native-nvim

        cellular-automaton
      ];
      extraConfig = ''
        set noemoji
      '';
      extraLuaConfig = ''
        ${builtins.readFile ./nvim/init.lua}
        ${builtins.readFile ./nvim/options.lua}
        ${builtins.readFile ./nvim/keymaps.lua}
        ${builtins.readFile ./nvim/plugins/which-key.lua}
        ${builtins.readFile ./nvim/plugins/autopairs.lua}
        ${builtins.readFile ./nvim/plugins/comment.lua}
        ${builtins.readFile ./nvim/plugins/luasnip.lua}
        ${builtins.readFile ./nvim/plugins/cmp.lua}
        ${builtins.readFile ./nvim/plugins/lsp.lua}
        ${builtins.readFile ./nvim/plugins/nvim-tree.lua}
        ${builtins.readFile ./nvim/plugins/telescope.lua}
        ${builtins.readFile ./nvim/plugins/todo-comments.lua}
        ${builtins.readFile ./nvim/plugins/treesitter.lua}
        ${builtins.readFile ./nvim/plugins/lualine.lua}
        ${builtins.readFile ./nvim/plugins/noice.lua}
        ${builtins.readFile ./nvim/plugins/catppuccin.lua}
        ${builtins.readFile ./nvim/plugins/alpha.lua}
        require("bufferline").setup{}
        require("oil").setup()
        -- require("startup").setup({theme = "evil"})
        require("fidget").setup{}
        -- require("render-markdown").setup{}
      '';
    };
  };
}
