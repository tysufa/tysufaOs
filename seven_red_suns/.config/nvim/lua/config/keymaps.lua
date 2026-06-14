vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

vim.keymap.set("n", "<M-j>", ":cnext<CR>")
vim.keymap.set("n", "<M-k>", ":cprev<CR>")

---------- allow you to go down, up, beginning and end of line in wraped lines -----------
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "^", "g^")
vim.keymap.set("n", "$", "g$")

-- show macro recording leave and enter
vim.api.nvim_create_autocmd("RecordingLeave", {
	callback = function(ev)
		local reg = vim.fn.reg_recording()
		vim.notify("recording " .. reg .. " over : " .. vim.v.event.regcontents, vim.log.levels.INFO)
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

cmd = "lua vim.opt.wrap = not vim.opt.wrap:get() ; "
vim.cmd(KeymapCommand("<leader>tw", vim.opt.wrap:get(), cmd, "line wrapping"))
vim.cmd(KeymapCommand("<leader>tw", vim.opt.wrap:get(), cmd, "line wrapping"))

-- return "lua ToggleFeature('" .. keymap .. "', " .. tostring(toggle_state) .. ", '" .. cmd .. "', '" .. desc .. "')"return "lua ToggleFeature('" .. keymap .. "', " .. tostring(toggle_state) .. ", '" .. cmd .. "', '" .. desc .. "')"return "lua ToggleFeature('" .. keymap .. "', " .. tostring(toggle_state) .. ", '" .. cmd .. "', '" .. desc .. "')"
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

----- USER COMMAND ------
vim.api.nvim_create_user_command("OpenPdf", function()
	local filepath = vim.api.nvim_buf_get_name(0)

	if filepath:match("%.typ$") then
		local pdf_path = filepath:gsub("%.typ$", ".pdf")

		vim.system({ "zathura", pdf_path })
	end
end, {})

---- MARKDOWN ----

vim.keymap.set("v", "<leader>lk", function()
	-- 1. Yank the visually selected text into register 'v'
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")

	-- 2. Open Neovim's native input prompt for the URL
	vim.ui.input({ prompt = "Paste URL: " }, function(url)
		if url and url ~= "" then
			-- 3. Format into a markdown link
			local markdown_link = string.format("[%s](%s)", text, url)
			-- 4. Overwrite the selection with the new link
			vim.fn.setreg("v", markdown_link)
			vim.cmd('normal! gv"vp')
		end
	end)
end, { desc = "Convert selected text into Markdown link" })

vim.keymap.set("n", "<leader>lk", function()
	-- 1. Grab the word under the cursor
	local text = vim.fn.expand("<cword>")

	-- 2. Prompt for the URL
	vim.ui.input({ prompt = "Paste URL: " }, function(url)
		if url and url ~= "" then
			-- 3. Format and replace the word
			local markdown_link = string.format("[%s](%s)", text, url)
			vim.fn.setreg("v", markdown_link)
			vim.cmd('normal! viw"vp')
		end
	end)
end, { desc = "Convert current word into Markdown link" })

local function sort_completed_tasks()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	-- 1. Find the header above the current cursor position
	local header_idx = nil
	for i = cursor_line, 1, -1 do
		if lines[i]:match("^#+%s") then
			header_idx = i
			break
		end
	end

	if not header_idx then
		vim.notify("No header found above the cursor!", vim.log.levels.WARN)
		return
	end

	-- 2. Find the next header or the end of the file to mark boundaries
	local next_header_idx = #lines + 1
	for i = header_idx + 1, #lines do
		if lines[i]:match("^#+%s") then
			next_header_idx = i
			break
		end
	end

	local start_range = header_idx + 1
	local end_range = next_header_idx - 1

	if start_range > end_range then
		return -- The section is empty
	end

	local active_lines = {}
	local completed_lines = {}

	-- 3. Parse lines within the section boundaries
	local i = start_range
	while i <= end_range do
		local line = lines[i]

		-- Matches standard markdown/vimwiki completed tasks: - [X] or - [x]
		if line:match("^%s*[-*]%s+%[[Xx]%]") then
			table.insert(completed_lines, line)

			-- Keep nested sub-tasks or notes attached to this completed task
			local current_indent = (line:match("^(%s*)") or ""):len()
			i = i + 1
			while i <= end_range do
				local next_line = lines[i]
				local next_indent = (next_line:match("^(%s*)") or ""):len()

				if
					#next_line > 0
					and not next_line:match("^%s*$")
					and next_indent > current_indent
					and not next_line:match("^#")
				then
					table.insert(completed_lines, next_line)
					i = i + 1
				else
					break
				end
			end
		else
			table.insert(active_lines, line)
			i = i + 1
		end
	end

	-- 4. Clean up trailing blank lines from active items to keep formatting tight
	local blank_count = 0
	while #active_lines > 0 and active_lines[#active_lines]:match("^%s*$") do
		table.remove(active_lines)
		blank_count = blank_count + 1
	end

	-- 5. Re-assemble the section: active tasks -> completed tasks -> trailing blanks
	local new_section = {}
	for _, l in ipairs(active_lines) do
		table.insert(new_section, l)
	end
	for _, l in ipairs(completed_lines) do
		table.insert(new_section, l)
	end
	for _ = 1, blank_count do
		table.insert(new_section, "")
	end

	-- 6. Write changes back to the active buffer
	vim.api.nvim_buf_set_lines(bufnr, start_range - 1, end_range, false, new_section)
end

-- Create a user command so you can type :SortTasks
vim.api.nvim_create_user_command("SortTasks", sort_completed_tasks, {})

-- Map it to a shortcut (e.g., <leader>ts for "Task Sort")
vim.keymap.set("n", "<leader>ts", sort_completed_tasks, { desc = "Sort completed tasks to bottom of header" })

---- TASKWIKI ----

-- Create an isolated namespace for our virtual lines
local ns_id = vim.api.nvim_create_namespace("taskwiki_completion_date")

-- Helper function to parse Taskwarrior's raw compact date strings safely
local function format_tw_date(raw_date)
	-- Formats compact syntax (20260614T150427Z)
	local y, m, d, h, min = raw_date:match("^(%d%d%d%d)(%d%d)(%d%d)T(%d%d)(%d%d)")
	if y then
		return string.format("%s-%s-%s %s:%s", y, m, d, h, min)
	end

	-- Formats dashed syntax (2026-06-14T15:04:27)
	y, m, d, h, min = raw_date:match("^(%d%d%d%d)-(%d%d)-(%d%d)T(%d%d):(%d%d)")
	if y then
		return string.format("%s-%s-%s %s:%s", y, m, d, h, min)
	end

	return raw_date
end

local function show_completion_date()
	-- 1. Instantly clear any existing completion virtual lines
	vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

	local line_num = vim.api.nvim_win_get_cursor(0)[1] - 1
	local line_text = vim.api.nvim_buf_get_lines(0, line_num, line_num + 1, false)[1] or ""

	-- 2. Guard: Only run if the cursor is sitting on a completed task (* [X])
	if not line_text:match("^%s*%*%s*%[X%]") then
		return
	end

	-- 3. Extract Taskwiki's trailing unique hash identifier (e.g. #a1b2c3d)
	local uuid = line_text:match("#([a-f0-9]+)%s*$")
	if not uuid then
		return
	end

	-- 4. Grab the raw completion time attribute ('end') directly out of Taskwarrior
	local cmd = string.format("task _get %s.end 2>/dev/null", uuid)
	local handle = io.popen(cmd)
	if not handle then
		return
	end
	local end_date = handle:read("*a")
	handle:close()

	end_date = vim.trim(end_date)
	if end_date == "" or end_date == "nil" then
		return
	end

	local formatted_date = format_tw_date(end_date)

	-- 5. Render a virtual line immediately below our task
	vim.api.nvim_buf_set_extmark(0, ns_id, line_num, 0, {
		virt_text = { { " ── Completed on: " .. formatted_date, "Comment" } },
		virt_text_pos = "eol", -- Places it right after your markdown text
	})
end

-- 6. Attach the listener to your cursor movements inside wiki markdown files
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	pattern = { "*.md", "*.wiki" },
	callback = show_completion_date,
})
