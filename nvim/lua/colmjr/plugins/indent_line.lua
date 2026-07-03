vim.pack.add { 'https://github.com/lukas-reineke/indent-blankline.nvim' }
require('ibl').setup { enabled = false }

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function() require('ibl').setup_buffer(0, { enabled = true }) end,
})
