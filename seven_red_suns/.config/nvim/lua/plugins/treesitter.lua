return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")
        
        -- Initialize the plugin base
        ts.setup()

        -- Install your language parsers (replaces ensure_installed)
        ts.install({ "c", "lua", "vim", "cpp", "vimdoc", "query" })

        -- Enable highlighting and indentation via standard Neovim autocommands
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(event)
                -- Respect your ignore_install preference
                if event.match == "javascript" then return end

                -- Turn on native tree-sitter highlighting
                pcall(vim.treesitter.start, event.buf)

                -- Turn on tree-sitter indentation
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
