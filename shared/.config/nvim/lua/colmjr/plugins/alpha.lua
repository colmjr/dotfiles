vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons', 'https://github.com/goolord/alpha-nvim' }
local theta = require 'alpha.themes.theta'
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
  { type = 'padding', val = 1 },
}
require('alpha').setup(theta.config)
