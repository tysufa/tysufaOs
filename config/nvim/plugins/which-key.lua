require('which-key').setup()

-- Document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]++'},
  ['<leader>f'] = { name = '[F]ile'},
  ['<leader>d'] = { name = '[D]ocument'},
  ['<leader>r'] = { name = '[R]ename'},
  ['<leader>s'] = { name = '[S]earch'},
  ['<leader>w'] = { name = '[W]orkspace'},
  ['<leader>t'] = { name = '[T]oggle'},
  ['<leader>h'] = { name = 'Git [H]unk'},
}

-- visual mode
require('which-key').register({
  ['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })
