vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false
-- line numbers
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.mousehide = false

-- sync keyboard clipboard with "+
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.o.breakindent = true
-- enables undo/redo after closing and reopening a file
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- the thing next to the numbers column
vim.o.signcolumn = 'yes'

vim.o.updatetime = 250
-- the time it considers chars to be part of the same command
-- if over than considers as new command
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

-- usually in zed you are not able to see
-- tabs, trailing spaces and non breaking spaces
-- here you can toggle that
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- able to preview substitutions
-- ex. :s/foo/bar
vim.o.inccommand = 'split'

vim.o.cursorline = true
vim.o.scrolloff = 7

-- if performing an operation that would fail due to unsaved changes in the buffer
-- raise a dialog asking if you wish to save the current file
vim.o.confirm = true
