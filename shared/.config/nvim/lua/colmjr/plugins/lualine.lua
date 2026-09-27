vim.pack.add { 'https://github.com/nvim-lualine/lualine.nvim' }

-- Flat lualine: explicit base background avoids inheriting StatusLine's mantle.
-- mode is just colored bold text instead of a filled pill.
-- macchiato palette, hardcoded so load order vs theme.lua does not matter.
local p = {
  base = '#24273a',
  blue = '#8aadf4',
  green = '#a6da95',
  mauve = '#c6a0f6',
  red = '#ed8796',
  peach = '#f5a97f',
  teal = '#8bd5ca',
  text = '#cad3f5',
  subtext0 = '#a5adcb',
  overlay1 = '#8087a2',
}
local function mode_section(color) return { fg = color, bg = p.base, gui = 'bold' } end
local flat = {
  normal = {
    a = mode_section(p.blue),
    b = { fg = p.text, bg = p.base },
    c = { fg = p.subtext0, bg = p.base },
  },
  insert = { a = mode_section(p.green) },
  visual = { a = mode_section(p.mauve) },
  replace = { a = mode_section(p.red) },
  command = { a = mode_section(p.peach) },
  terminal = { a = mode_section(p.teal) },
  inactive = {
    a = { fg = p.overlay1, bg = p.base },
    b = { fg = p.overlay1, bg = p.base },
    c = { fg = p.overlay1, bg = p.base },
  },
}

require('lualine').setup {
  options = {
    theme = flat,
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
