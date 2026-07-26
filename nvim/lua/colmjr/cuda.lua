-- PMPP / CUDA-on-Modal workflow: edit .cu files locally, compile & run them
-- on a Modal T4 GPU (scripts in ~/dev/pmpp/scripts).
-- One-time setup: uv tool install modal && modal setup

local root = vim.fs.normalize '~/dev/pmpp'

local function in_term(cmd)
  vim.cmd 'botright 15split | enew'
  vim.fn.termopen(cmd)
  vim.cmd.startinsert()
end

vim.api.nvim_create_user_command('GpuShell', function() in_term(root .. '/scripts/cshell') end, { desc = 'Shell in the Modal GPU container' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cuda',
  group = vim.api.nvim_create_augroup('colmjr-cuda', { clear = true }),
  callback = function(ev)
    vim.keymap.set('n', '<leader>rr', function()
      vim.cmd.write()
      in_term(('%s/scripts/crun %s'):format(root, vim.fn.shellescape(vim.api.nvim_buf_get_name(ev.buf))))
    end, { buffer = ev.buf, desc = 'CUDA: compile & [r]un on Modal GPU' })
    vim.keymap.set('n', '<leader>rt', '<cmd>GpuShell<cr>', { buffer = ev.buf, desc = 'CUDA: GPU container [t]erminal' })
  end,
})

-- vim: ts=2 sts=2 sw=2 et
