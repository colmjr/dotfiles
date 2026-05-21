vim.keymap.set('x', 'Y', 'yy')
vim.keymap.set('x', 'D', 'dd')
vim.keymap.set('n', '<leader>w', '<C-w>')

-- centering remaps lol
-- the reason why we dont do this for gg is that zz doesnt work with gg
vim.keymap.set({ 'n', 'x' }, 'G', [[Gzz]])
vim.keymap.set('n', '<C-d>', '<C-d> zz')
vim.keymap.set('n', '<C-u>', '<C-u> zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- for exiting terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')

-- register keybind magic
vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set({ 'n', 'v' }, '<leader>Y', [["+Y]])
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

-- wincmd magic
vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
vim.keymap.set('n', '<C-k>', '<C-w><C-k>')
