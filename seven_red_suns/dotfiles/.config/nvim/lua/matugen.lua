 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#15130f',
    base01 = '#221f1b',
    base02 = '#2c2a25',
    base03 = '#989081',
    base04 = '#cfc5b5',
    base05 = '#e8e1da',
    base06 = '#e8e1da',
    base07 = '#e8e1da',
    base08 = '#ffb4ab',
    base09 = '#f6ffd3',
    base0A = '#d4c5a7',
    base0B = '#fffaf6',
    base0C = '#c0cc95',
    base0D = '#dfc486',
    base0E = '#d4c5a7',
    base0F = '#f1e1c2',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#e8e1da',          bg = '#15130f' })
  hi('TelescopeBorder',         { fg = '#989081',             bg = '#15130f' })
  hi('TelescopePromptNormal',   { fg = '#e8e1da',          bg = '#15130f' })
  hi('TelescopePromptBorder',   { fg = '#989081',             bg = '#15130f' })
  hi('TelescopePromptPrefix',   { fg = '#fffaf6',             bg = '#15130f' })
  hi('TelescopePromptCounter',  { fg = '#cfc5b5',  bg = '#15130f' })
  hi('TelescopePromptTitle',    { fg = '#15130f',             bg = '#fffaf6' })
  hi('TelescopePreviewTitle',   { fg = '#15130f',             bg = '#d4c5a7' })
  hi('TelescopeResultsTitle',   { fg = '#15130f',             bg = '#f6ffd3' })
  hi('TelescopeSelection',      { fg = '#e8e1da',          bg = '#2c2a25' })
  hi('TelescopeSelectionCaret', { fg = '#fffaf6',             bg = '#2c2a25' })
  hi('TelescopeMatching',       { fg = '#fffaf6',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#e8e1da',          bg = '#15130f' })
  hi('MiniPickBorder',         { fg = '#989081',             bg = '#15130f' })
  hi('MiniPickPrompt',   { fg = '#e8e1da',          bg = '#15130f' })
  hi('MiniPickPromptPrefix',   { fg = '#fffaf6',             bg = '#15130f' })
  hi('MiniPickBorderText',    { fg = '#15130f',             bg = '#fffaf6' })
  hi('MiniPickMatchCurrent',      { fg = '#e8e1da',          bg = '#2c2a25' })
  hi('MiniPickPromptCaret', { fg = '#fffaf6',             bg = '#2c2a25' })
  hi('MiniPickMatchRanges',       { fg = '#fffaf6',             bold = true })
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
