vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:"

-- vim.o.statuscolumn = "%C%s%=%{v:relnum?v:relnum:v:lnum} "

return {
	"kevinhwang91/nvim-ufo",

	dependencies = { "kevinhwang91/promise-async" },

	init = function()
		vim.o.foldcolumn = "auto"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
	end,

	config = function()
		-- Keymaps
		vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
		-- vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
		-- vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)

		vim.keymap.set("n", "K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
		end, { desc = "Peek fold or LSP hover" })

		-- Setup ufo with LSP primary provider and treesitter/indent fallback
		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "lsp", "indent" }
			end,
		})
	end,
}
