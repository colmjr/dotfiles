vim.pack.add {
  'https://github.com/ellisonleao/gruvbox.nvim',
}

require('gruvbox').setup { contrast = '', transparent_mode = false }
vim.opt.background = 'dark'
vim.cmd 'colorscheme gruvbox'
