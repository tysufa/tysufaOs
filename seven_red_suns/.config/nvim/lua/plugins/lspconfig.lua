return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Allows extra capabilities provided by blink.cmp
		"saghen/blink.cmp",
	},
	config = function()
		-- 1. Grab completion capabilities from blink.cmp
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Set global defaults for ALL configurations so you don't have to map capabilities manually
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- 2. Centralized Server Tables
		local servers = {
			pyright = {},
			qmlls = {},
			clangd = {
				settings = {
					clangd = {
						InlayHints = {
							Designators = true,
							Enabled = true,
							ParameterNames = true,
							DeducedTypes = true,
						},
					},
				},
			},
			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						hint = { enable = true, setType = true, semicolon = "All" },
					},
				},
			},
			tinymist = {
				cmd = { "tinymist" },
				filetypes = { "typst" },
				settings = { exportPdf = "onType" },
			},
			nixd = {
				settings = {
					nixd = {
						nixpkgs = { expr = "import <nixpkgs> { }" },
						formatting = { command = { "alejandra" } },
					},
				},
			},
		}

		-- 3. Loop through configs, load options, and enable them properly
		for server_name, config_opts in pairs(servers) do
			vim.lsp.config(server_name, config_opts)
			vim.lsp.enable(server_name)
		end

		-- 4. Safe, non-blocking Spinner Notifications for LSP progress
		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.api.nvim_create_autocmd("LspProgress", {
			---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
			callback = function(ev)
				local value = ev.data.params.value
				-- Only notify if there is a status update to avoid high-frequency rendering stutters
				if value and (value.kind == "begin" or value.kind == "report" or value.kind == "end") then
					vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
						id = "lsp_progress",
						title = "LSP Progress",
						opts = function(notif)
							notif.icon = value.kind == "end" and " "
								or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
						end,
					})
				end
			end,
		})
	end,
}
