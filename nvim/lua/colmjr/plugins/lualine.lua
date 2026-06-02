vim.pack.add { 'https://github.com/nvim-lualine/lualine.nvim' }
require('lualine').setup {
  options = {
    icons_enabled = vim.g.have_nerd_font,
  },
  sections = {
    -- cursor location as LINE:COLUMN
    lualine_z = { '%2l:%-2v' },
  },
}
