return {
	"MeanderingProgrammer/render-markdown.nvim",
	-- 1. Tell lazy.nvim to load the plugin for BOTH filetypes
	ft = { "markdown", "vimwiki" },

	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },

	opts = {
		-- 2. Tell the plugin itself to run on vimwiki files
		-- file_types = { "markdown", "vimwiki" },
		file_types = { "markdown", "vimwiki" },

		-- Your existing configuration options...
	},
}
