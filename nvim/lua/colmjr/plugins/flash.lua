vim.pack.add { 'https://github.com/folke/flash.nvim' }

-- Enhances f/F/t/T (multi-line + ;/, repeat) automatically once setup runs.
-- Set char.jump_labels = true if you want f/t to also show jump labels.
require('flash').setup { modes = { char = { jump_labels = true } } }

-- `s` to jump anywhere on screen by typing chars then pressing a label.
-- Works in normal (move), visual (extend selection), and operator-pending.
vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })

-- `S` to select/expand by treesitter node (function, block, argument, ...).
-- no collision with surround i think
vim.keymap.set({ 'n', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })

-- `r` in operator-pending: act on a remote location without moving the cursor (e.g. `yr`).
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })

-- `R` to search by treesitter node in operator-pending / visual.
vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, { desc = 'Treesitter Search' })

-- toggle flash in search
vim.keymap.set('c', '<C-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })
