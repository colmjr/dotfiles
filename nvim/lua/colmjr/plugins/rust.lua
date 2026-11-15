vim.g.rustaceanvim = {
  dap = {
    -- Import toolchain formatters even when CodeLLDB's automatic loader fails.
    load_rust_types = true,
  },
  server = {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    default_settings = {
      ['rust-analyzer'] = {
        checkOnSave = true,
      },
    },
  },
}

vim.pack.add {
  {
    src = 'https://github.com/mrcjkb/rustaceanvim',
    version = vim.version.range '^9',
  },
}
