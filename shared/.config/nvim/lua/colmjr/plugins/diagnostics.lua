-- DIAGNOSTIC CONFIG
vim.pack.add { 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' }
require('tiny-inline-diagnostic').setup {
  preset = 'minimal',
  signs = {
    diag = '',
    arrow = '',
    up_arrow = '',
    vertical = '',
    vertical_end = '',
  },
  options = {
    show_source = { enabled = true, if_many = true },
    -- strip GHC's bullet markers from message text
    format = function(diag) return (diag.message:gsub('•%s*', '')) end,
    -- errors stay visible on every line, other severities only on the cursor line
    multilines = { enabled = true, always_show = true, severity = { vim.diagnostic.severity.ERROR } },
    -- when a line has multiple diagnostics, only show the most severe one
    add_messages = { messages = true, use_max_severity = true },
    -- drop HINT entirely
    severity = {
      vim.diagnostic.severity.ERROR,
      vim.diagnostic.severity.WARN,
      vim.diagnostic.severity.INFO,
    },
    -- diagnostics are hidden in insert mode by default (enable_on_insert = false)
  },
}

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  -- no signs (the circles) in the sign column
  signs = false,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- tiny-inline-diagnostic renders its own inline messages
  virtual_text = false,
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

-- toggle tiny-inline-diagnostic; keeps underline + signs
vim.keymap.set('n', '<leader>td', function() require('tiny-inline-diagnostic').toggle() end, { desc = '[T]oggle inline [D]iagnostics' })
