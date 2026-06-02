vim.pack.add { 'https://github.com/folke/which-key.nvim' }
require('which-key').setup {
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  -- Document existing key chains
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
    { '<leader>w', group = '[W]indow', mode = { 'n', 'v' } },
    { '<leader>p', group = '[P]aste without register', mode = { 'x' } }, -- yes I know it is called a blackhole register
    { '<leader>y', group = '[Y]ank to clipboard', mode = { 'n', 'v' } },
    { '<leader>Y', group = '[Y]ank line to clipboard', mode = { 'n', 'v' } },
    { '<leader>d', group = '[D]elete without register', mode = { 'n', 'v' } },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}
