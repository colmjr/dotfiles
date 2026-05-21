vim.keymap.set('x', 'Y', 'yy')
vim.keymap.set('x', 'D', 'dd')
vim.keymap.set('n', '<leader> w', '<C-w>')

-- centering remaps lol
vim.keymap.set('n', '<C-d>', '<C-d> zz')
vim.keymap.set('n', '<C-d>', '<C-u> zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('x', '<leader> p', [["_dP]])
vim.keymap.set({ 'n', 'v' }, '<leader> y', [["+y]])
vim.keymap.set({ 'n', 'v' }, '<leader> Y', [["+Y]])
vim.keymap.set({ 'n', 'v' }, '<leader> d', [["_d]])
