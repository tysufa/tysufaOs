return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")

		-- Initialize the plugin base
		ts.setup()

		-- Install your language parsers
		ts.install({ "c", "lua", "vim", "cpp", "vimdoc", "query" })

		-- Enable highlighting and indentation via standard Neovim autocommands
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(event)
				-- FIX: Add "markdown" and "vimwiki" to your ignore list here!
				local ignore_types = { "javascript", "markdown", "vimwiki" }
				if vim.tbl_contains(ignore_types, event.match) then
					return
				end

				-- Turn on native tree-sitter highlighting safely
				pcall(vim.treesitter.start, event.buf)

				-- Turn on tree-sitter indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
