vim.pack.add { 'https://github.com/nvim-lualine/lualine.nvim' }
require('lualine').setup {
  options = {
    icons_enabled = vim.g.have_nerd_font,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { { 'filename', path = 1 } }, -- relative path
    lualine_x = { 'diagnostics', 'filetype' },
    lualine_y = {},
    lualine_z = { '%2l:%-2v' }, -- cursor location as LINE:COLUMN
  },
}
