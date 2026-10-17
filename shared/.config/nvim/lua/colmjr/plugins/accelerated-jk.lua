vim.pack.add { 'https://github.com/rhysd/accelerated-jk' }

vim.g.accelerated_jk_acceleration_limit = 150

vim.keymap.set('n', 'j', '<Plug>(accelerated_jk_gj)', { remap = true })
vim.keymap.set('n', 'k', '<Plug>(accelerated_jk_gk)', { remap = true })
