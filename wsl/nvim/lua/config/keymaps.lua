vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>cl', '<CMD>Noice dismiss<CR>', { desc = 'Open diagnostic [Q]uickfix list' })


vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<space><space>x', "<cmd>source %<CR>")
vim.keymap.set('n', '<space>x', ":.lua<CR>")
vim.keymap.set('v', '<space>x', ":lua<CR>")

vim.keymap.set('n', '<space><space>l', ":set wrap!<CR>")

vim.keymap.set('n', '<M-j>', ":cnext<CR>")
vim.keymap.set('n', '<M-k>', ":cprev<CR>")


vim.keymap.set('n', '-', ":Oil<CR>")
