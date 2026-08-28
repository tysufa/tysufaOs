return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			cpp = { "astyle" },
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},

		formatters = {
			astyle = {
				-- prepend_args = "--project",
				env = {
					ARTISTIC_STYLE_PROJECT_OPTIONS = ".astylerc",
				},
			},
			yamlfix = {
				-- Change where to find the command
				command = "local/path/yamlfix",
				-- Adds environment args to the yamlfix formatter
				env = {
					YAMLFIX_SEQUENCE_STYLE = "block_style",
				},
				prepend_args = { "-i", "2" },
			},
		},

		format_on_save = {
			-- I recommend these options. See :help conform.format for details.
			lsp_format = "fallback",
			timeout_ms = 500,
		},
	},
}
