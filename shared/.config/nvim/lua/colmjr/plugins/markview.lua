vim.pack.add {
  'https://github.com/OXY2DEV/markview.nvim',
}
require('markview').setup {
  preview = {
    -- replaces the default list ('tex' is not in it); needs the latex/typst
    -- treesitter parsers, installed via treesitter.lua
    -- 'org' isn't natively supported: it only renders typst/latex injected
    -- into #+begin_src blocks by orgmode's treesitter injections
    filetypes = { 'markdown', 'quarto', 'rmd', 'typst', 'tex', 'org' },
    -- markview's gx only understands markdown/html link nodes and silently
    -- does nothing on org links; it also attaches after FileType, so leaving
    -- this on would clobber the org gx mapping set in orgmode.lua
    map_gx = false,
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'quarto', 'rmd' },
  group = vim.api.nvim_create_augroup('markview-gx', { clear = true }),
  callback = function(event) vim.keymap.set('n', 'gx', '<cmd>Markview open<cr>', { buffer = event.buf, desc = 'Open link (markview)' }) end,
})
