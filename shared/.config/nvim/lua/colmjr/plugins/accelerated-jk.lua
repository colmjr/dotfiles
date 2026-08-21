vim.pack.add { 'https://github.com/rhysd/accelerated-jk' }

-- reset the acceleration step if a key-repeat takes longer than this (ms)
vim.g.accelerated_jk_acceleration_limit = 150

-- time-driven (timewise) acceleration -- remap = true since these are <Plug> maps
vim.keymap.set('n', 'j', '<Plug>(accelerated_jk_gj)', { remap = true })
vim.keymap.set('n', 'k', '<Plug>(accelerated_jk_gk)', { remap = true })
