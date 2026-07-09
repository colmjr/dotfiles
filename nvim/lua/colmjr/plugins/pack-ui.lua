vim.pack.add { 'https://github.com/jtprogru/pack-ui.nvim' }
require('pack_ui').setup {
  auto_check = true, -- on setup, check remotes and notify if updates exist
  auto_update = false, -- on setup, apply every available update automatically
  keymaps = {
    prefix = '<leader>p',
    status = 's', -- :PackStatus
    update_all = 'U', -- PackUpdateAll
  },
}
