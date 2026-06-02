vim.pack.add { 'https://github.com/echasnovski/mini.ai' }
require('mini.ai').setup {
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}
