local opt = vim.opt
local g = vim.g

-- go to previous/next line when at last character
opt.whichwrap = '<,>,l,h'

opt.foldmethod = 'manual'
opt.foldcolumn = '1'

--disable netrw to use nvim-tree
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

opt.termguicolors = true

opt.number = true
opt.relativenumber = true

-- Enable mouse mode
opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
opt.showmode = false

opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default (gitsign)
opt.signcolumn = 'yes'
-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.termguicolors = true
opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
