---@diagnostic disable: missing-fields
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
        require("nvim-treesitter.configs").setup({
            auto_install = false,
            ignore_install = { "javascript" },
            ensure_installed = { "c", "lua", "vim", "cpp"},
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Enter>", -- set to `false` to disable one of the mappings
                    node_incremental = "<Enter>",
                    scope_incremental = false,
                    node_decremental = "<Backspace>",
                },
            },
        })
    end
}
