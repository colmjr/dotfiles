vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons', 'https://github.com/goolord/alpha-nvim' }
local theta = require 'alpha.themes.theta'
local dashboard = require 'alpha.themes.dashboard'
theta.file_icons.provider = 'devicons'
theta.header.val = {
  '                                                                     ',
  '       ████ ██████           █████      ██                     ',
  '      ███████████             █████                             ',
  '      █████████ ███████████████████ ███   ███████████   ',
  '     █████████  ███    █████████████ █████ ██████████████   ',
  '    █████████ ██████████ █████████ █████ █████ ████ █████   ',
  '  ███████████ ███    ███ █████████ █████ █████ ████ █████  ',
  ' ██████  █████████████████████ ████ █████ █████ ████ ██████ ',
}

theta.buttons.val = {
  { type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
  { type = 'padding', val = 1 },
  dashboard.button('e', 'New file', '<cmd>ene <BAR> startinsert<cr>'),
  dashboard.button('f', 'Find file', '<cmd>Telescope find_files<cr>'),
  dashboard.button('r', 'Recent files', '<cmd>Telescope oldfiles<cr>'),
  dashboard.button('g', 'Find text', '<cmd>Telescope live_grep<cr>'),
  dashboard.button('c', 'Config', '<cmd>cd ~/.config/nvim | e init.lua<cr>'),
  dashboard.button('q', 'Quit', '<cmd>qa<cr>'),
}
require('alpha').setup(theta.config)
