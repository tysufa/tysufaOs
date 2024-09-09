{ pkgs, ... }:
{
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      # vimAlias = true; vimdiffAlias = true;
      withNodeJs = true;
      extraPackages = with pkgs; [
        lua-language-server
        gopls
        wl-clipboard
        luajitPackages.lua-lsp
        nil
        rust-analyzer
        # nodePackages.bash-language-server
        yaml-language-server
        pyright
        marksman
      ];
      plugins = with pkgs.vimPlugins; [
        mini-nvim # dependencie for render-markdown
        render-markdown
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
        nvim-treesitter.withAllGrammars
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
        luasnip
        telescope-nvim
        todo-comments-nvim
        nvim-tree-lua
        telescope-fzf-native-nvim
      ];
      extraConfig = ''
        set noemoji
      '';
      extraLuaConfig = ''
        ${builtins.readFile ./nvim/init.lua}
        ${builtins.readFile ./nvim/options.lua}
        ${builtins.readFile ./nvim/plugins/which-key.lua}
        ${builtins.readFile ./nvim/plugins/autopairs.lua}
        ${builtins.readFile ./nvim/plugins/comment.lua}
        ${builtins.readFile ./nvim/plugins/cmp.lua}
        ${builtins.readFile ./nvim/plugins/lsp.lua}
        ${builtins.readFile ./nvim/plugins/nvim-tree.lua}
        ${builtins.readFile ./nvim/plugins/telescope.lua}
        ${builtins.readFile ./nvim/plugins/todo-comments.lua}
        ${builtins.readFile ./nvim/plugins/treesitter.lua}
        ${builtins.readFile ./nvim/plugins/lualine.lua}
        ${builtins.readFile ./nvim/plugins/noice.lua}
        ${builtins.readFile ./nvim/keymaps.lua}
        require("bufferline").setup{}
        require("startup").setup({theme = "evil"})
        require("fidget").setup{}
        require("render-markdown").setup{}
      '';
    };
  };
}
