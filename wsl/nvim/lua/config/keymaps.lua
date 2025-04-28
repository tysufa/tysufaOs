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

-- show macro recording leave and enter
vim.api.nvim_create_autocmd("RecordingLeave", {
	callback = function(ev)
		local reg = vim.fn.reg_recording()
		vim.notify("recording " .. reg .. "over : " .. vim.v.event.regcontents, vim.log.levels.INFO)
	end,
})

local wk = require("which-key")

-- Generalized toggle function
function ToggleFeature(keymap, toggle_state, cmd, description)
	vim.cmd(cmd)
	toggle_state = not toggle_state

	local desc = toggle_state and "  " .. description or "  " .. description

	vim.keymap.set("n", keymap, function()
		vim.cmd(KeymapCommand(keymap, toggle_state, cmd, description))
	end, { desc = desc })
	return toggle_state
end

function KeymapCommand(keymap, toggle_state, cmd, desc)
	return "lua ToggleFeature('" .. keymap .. "', " .. tostring(toggle_state) .. ", '" .. cmd .. "', '" .. desc .. "')"
end

local cmd = "lua vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })"
vim.cmd(KeymapCommand("<leader>tl", vim.diagnostic.config().virtual_lines, cmd, "virtual lines"))
vim.cmd(KeymapCommand("<leader>tl", vim.diagnostic.config().virtual_lines, cmd, "virtual lines"))

cmd = "lua vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })"
vim.cmd(KeymapCommand("<leader>tt", vim.diagnostic.config().virtual_text, cmd, "virtual text"))
vim.cmd(KeymapCommand("<leader>tt", vim.diagnostic.config().virtual_text, cmd, "virtual text"))

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
