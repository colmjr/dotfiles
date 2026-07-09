vim.pack.add {
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/sindrets/diffview.nvim', -- optional: better diff views, auto-detected by neogit
}

require('neogit').setup {
  kind = 'replace',
}

vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Show Neogit UI' })
