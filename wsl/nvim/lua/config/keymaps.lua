vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

vim.keymap.set("n", "<M-j>", ":cnext<CR>")
vim.keymap.set("n", "<M-k>", ":cprev<CR>")

vim.keymap.set("n", "gp", ":bnext<CR>")
vim.keymap.set("n", "gP", ":bprev<CR>")

-- virtual text and lines toggles
local virtual_text_enabled = true
local virtual_line_enabled = false

function ToggleDiagnostics(is_virtual_line)
	if is_virtual_line then
		virtual_line_enabled = not virtual_line_enabled
		vim.diagnostic.config({
			virtual_lines = virtual_line_enabled and { current_line = false },
			virtual_text = virtual_text_enabled and { current_line = true },
		})
		print("Virtual line " .. (virtual_text_enabled and "ON" or "OFF"))
	else
		virtual_text_enabled = not virtual_text_enabled
		vim.diagnostic.config({
			virtual_lines = virtual_line_enabled and { current_line = false },
			virtual_text = virtual_text_enabled and { current_line = true },
		})
		print("Virtual text " .. (virtual_text_enabled and "ON" or "OFF"))
	end
end

vim.keymap.set("n", "<leader>tvl", function()
	ToggleDiagnostics(true)
end, { desc = "Toggle virtual text" })
vim.keymap.set("n", "<leader>tvt", function()
	ToggleDiagnostics(false)
end, { desc = "Toggle virtual lines" })

-- show macro recording leave and enter
vim.api.nvim_create_autocmd("RecordingLeave", {
	callback = function(ev)
		local reg = vim.fn.reg_recording()
		vim.notify("recording " .. reg .. "over : " .. vim.v.event.regcontents, vim.log.levels.INFO)
	end,
})

-- make a hovering info for diagnostics
vim.keymap.set("n", "<leader>e", function()
	local diag = vim.diagnostic.get(0, {
		lnum = vim.api.nvim_win_get_cursor(0)[1] - 1,
	})[1]
	if diag then
		vim.lsp.util.open_floating_preview(
			vim.split(diag.message, "\n"),
			"markdown",
			{ border = "rounded", max_width = 80 }
		)
	end
end, { desc = "Show full diagnostic" })
