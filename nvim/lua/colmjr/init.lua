require 'colmjr.set'
require 'colmjr.remap'
require 'colmjr.plugin'

do
  -- DIAGNOSTIC CONFIG
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    virtual_text = true, -- diagnostic is shown after the line, not in the next line
    virtual_lines = false,

    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  -- show quickfixes
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- toggle inline (virtual text) diagnostics; keeps underline + signs
  vim.keymap.set('n', '<leader>td', function()
    local enabled = vim.diagnostic.config().virtual_text
    vim.diagnostic.config { virtual_text = not enabled }
  end, { desc = '[T]oggle inline [D]iagnostics' })

  -- hide diagnostics while typing; show + refresh them on returning to normal mode
  local diag_insert = vim.api.nvim_create_augroup('colmjr-diag-insert', { clear = true })
  vim.api.nvim_create_autocmd('InsertEnter', {
    group = diag_insert,
    desc = 'Hide diagnostics while typing',
    callback = function() vim.diagnostic.enable(false, { bufnr = 0 }) end,
  })
  vim.api.nvim_create_autocmd('InsertLeave', {
    group = diag_insert,
    desc = 'Show diagnostics on leaving insert mode',
    callback = function() vim.diagnostic.enable(true, { bufnr = 0 }) end,
  })

  -- highlight on yank
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })
end
