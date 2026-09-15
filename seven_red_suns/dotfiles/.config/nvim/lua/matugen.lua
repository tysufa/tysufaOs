 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#151217',
    base01 = '#221e23',
    base02 = '#2c292e',
    base03 = '#978e9a',
    base04 = '#cec3d0',
    base05 = '#e8e0e7',
    base06 = '#e8e0e7',
    base07 = '#e8e0e7',
    base08 = '#ffb4ab',
    base09 = '#ffb0ca',
    base0A = '#d5bfe1',
    base0B = '#e2b6ff',
    base0C = '#ffb0ca',
    base0D = '#e2b6ff',
    base0E = '#d5bfe1',
    base0F = '#f2dafe',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#e8e0e7',          bg = '#151217' })
  hi('TelescopeBorder',         { fg = '#978e9a',             bg = '#151217' })
  hi('TelescopePromptNormal',   { fg = '#e8e0e7',          bg = '#151217' })
  hi('TelescopePromptBorder',   { fg = '#978e9a',             bg = '#151217' })
  hi('TelescopePromptPrefix',   { fg = '#e2b6ff',             bg = '#151217' })
  hi('TelescopePromptCounter',  { fg = '#cec3d0',  bg = '#151217' })
  hi('TelescopePromptTitle',    { fg = '#151217',             bg = '#e2b6ff' })
  hi('TelescopePreviewTitle',   { fg = '#151217',             bg = '#d5bfe1' })
  hi('TelescopeResultsTitle',   { fg = '#151217',             bg = '#ffb0ca' })
  hi('TelescopeSelection',      { fg = '#e8e0e7',          bg = '#2c292e' })
  hi('TelescopeSelectionCaret', { fg = '#e2b6ff',             bg = '#2c292e' })
  hi('TelescopeMatching',       { fg = '#e2b6ff',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
