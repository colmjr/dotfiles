vim.pack.add {
  'https://github.com/OXY2DEV/markview.nvim',
}
require('markview').setup {
  preview = {
    -- replaces the default list ('tex' is not in it); needs the latex/typst
    -- treesitter parsers, installed via treesitter.lua
    filetypes = { 'markdown', 'quarto', 'rmd', 'typst', 'tex' },
  },
}
