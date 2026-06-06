vim.pack.add { 'https://github.com/MunifTanjim/nui.nvim', { src = 'https://github.com/xeluxee/competitest.nvim' } }

require('competitest').setup {
  compile_command = {
    cpp = { exec = 'g++', args = { '-std=c++17', '-Wall', '$(FNAME)', '-o', '$(FNOEXT)' } },
  },
  run_command = {
    cpp = { exec = './$(FNOEXT)' },
  },
  received_files_extension = 'cpp',
  received_problems_path = '$(CWD)/$(PROBLEM).$(FEXT)',
  received_problems_prompt = false,
  template_file = '~/.config/nvim/templates/cp.cpp',
  evaluate_template_modifiers = true,
  maximum_time = 5000,
  -- always listening from startup, so you can queue problems anytime:
  start_receiving_persistently_on_setup = true,
}

vim.keymap.set('n', '<leader>cr', '<cmd>CompetiTest run<cr>', { desc = 'CP: run tests' })
vim.keymap.set('n', '<leader>cp', '<cmd>CompetiTest receive problem<cr>', { desc = 'CP: receive problem' })
vim.keymap.set('n', '<leader>cc', '<cmd>CompetiTest receive contest<cr>', { desc = 'CP: receive contest' })
vim.keymap.set('n', '<leader>cP', '<cmd>CompetiTest receive persistently<cr>', { desc = 'CP: receive persistently' })
vim.keymap.set('n', '<leader>cs', '<cmd>CompetiTest receive stop<cr>', { desc = 'CP: stop receiving' })
vim.keymap.set('n', '<leader>ce', '<cmd>CompetiTest edit_testcase<cr>', { desc = 'CP: edit testcase' })
vim.keymap.set('n', '<leader>ca', '<cmd>CompetiTest add_testcase<cr>', { desc = 'CP: add testcase' })
