-- vim.pack.add { 'https://github.com/rebelot/kanagawa.nvim' }
-- require('kanagawa').setup {
--   theme = 'wave', -- Load "wave" theme
--   background = { -- map the value of 'background' option to a theme
--     dark = 'wave', -- try "dragon" !
--     light = 'lotus',
--   },
-- }
-- vim.cmd 'colorscheme kanagawa'

vim.pack.add {
  {
    src = 'https://github.com/catppuccin/nvim',
    name = 'catppuccin',
  },
}
require('catppuccin').setup {
  flavour = 'macchiato',
}
vim.cmd 'colorscheme catppuccin-macchiato'
