vim.g.canola = {
  columns = { 'icon' },
}

vim.pack.add {
  { src = 'https://forge.barrettruth.com/barrettruth/canola.nvim', version = 'canola' },
}

vim.keymap.set('n', '-', '<CMD>Canola<CR>', { desc = 'Open parent directory' })
