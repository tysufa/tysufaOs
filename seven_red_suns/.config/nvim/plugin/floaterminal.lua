local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function FloatingTerm(opts)
  opts = opts or {}
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2 - 1)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = opts.border or 'single',
  })

  return { buf = buf, win = win}
end

-- Example usage:
-- FloatingTerm() -- Opens default shell

local toggle_term = function ()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = FloatingTerm({border="rounded", buf=state.floating.buf})
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
    vim.api.nvim_feedkeys("i", "n", false)
    -- alternative : vim.cmd("normal i")
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command("Floatingterm", toggle_term, {})

vim.keymap.set({ "t", "n" }, "<space>tt",toggle_term)
