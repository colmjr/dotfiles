vim.pack.add { 'https://github.com/windwp/nvim-autopairs' }

local autopairs = require 'nvim-autopairs'

-- autopairs' own map_cr installs an *expr* <CR> map whose result is already
-- termcode-escaped. orgmode's org_return fallback evals that map and runs
-- nvim_replace_termcodes over the result again, which turns <Cmd>/<Up>/<End>
-- into literal `<80>...` text in the buffer (Enter between {} in a src block).
-- A non-expr callback map sidesteps it: org_return calls this and, seeing
-- expr == 0, feeds nothing itself.
autopairs.setup { map_cr = false }

vim.keymap.set('i', '<CR>', function() vim.api.nvim_feedkeys(autopairs.completion_confirm(), 'n', false) end, { desc = 'autopairs completion confirm' })
