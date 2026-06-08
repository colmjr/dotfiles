vim.pack.add { 'https://github.com/MunifTanjim/nui.nvim', { src = 'https://github.com/xeluxee/competitest.nvim' } }

require('competitest').setup {
  compile_command = {
    -- g++-15 = real Homebrew GCC (matches Codeforces; gives pb_ds, __int128).
    -- ASan/UBSan don't link with Homebrew GCC on macOS, so -D_GLIBCXX_DEBUG is
    -- the working substitute: runtime bounds-checks on STL containers.
    -- $(FABSPATH) (not $(FNAME)) so the source resolves from the build/ cwd
    cpp = { exec = 'g++-15', args = {
      '-std=c++20', '-O2', '-Wall', '-Wextra', '-Wshadow',
      '-D_GLIBCXX_DEBUG', '-D_GLIBCXX_ASSERTIONS',
      '$(FABSPATH)', '-o', '$(FNOEXT)',
    } },
  },
  run_command = {
    cpp = { exec = './$(FNOEXT)' },
  },
  received_files_extension = 'cpp',
  received_problems_path = '$(HOME)/dev/Problems/$(PROBLEM).$(FEXT)',
  -- prompt shows the pre-filled save path on each receive: <Enter> saves,
  -- <Esc> cancels — so re-receiving a solved problem won't silently clobber it
  received_problems_prompt_path = true,
  received_contests_directory = '$(HOME)/dev/Problems/$(CONTEST)',
  received_contests_prompt_directory = false,
  received_contests_prompt_extension = false,
  template_file = '~/.config/nvim/templates/cp.cpp',
  evaluate_template_modifiers = true,
  maximum_time = 5000,
  -- keep the problem folder tidy: collapse a problem's samples into one
  -- "<name>.testcases" file, tucked in a tests/ subdir next to the source
  testcases_use_single_file = true,
  testcases_directory = 'tests',
  -- compiled binaries go in build/ (auto-created), not next to the source
  compile_directory = 'build',
  running_directory = 'build',
  -- NOT auto-listening at startup: with several tmux nvim sessions, only one
  -- process can hold port 27121, so auto-listen races. Receiving is explicit
  -- (see keymaps below): press a key in the nvim you want to receive into,
  -- then click the browser extension. Only one nvim should listen at a time.
}

vim.keymap.set('n', '<leader>cr', '<cmd>CompetiTest run<cr>', { desc = 'CP: run tests' })
-- single problem: one-shot, no modal — press, then click the extension
vim.keymap.set('n', '<leader>cp', '<cmd>CompetiTest receive problem<cr>', { desc = 'CP: receive problem' })
-- whole contest: press, then click the extension on the contest page
vim.keymap.set('n', '<leader>cc', '<cmd>CompetiTest receive contest<cr>', { desc = 'CP: receive contest' })
-- keep listening for many problems (single problems prompt testcases/problem)
vim.keymap.set('n', '<leader>cP', '<cmd>CompetiTest receive persistently<cr>', { desc = 'CP: receive persistently' })
vim.keymap.set('n', '<leader>cs', '<cmd>CompetiTest receive stop<cr>', { desc = 'CP: stop receiving' })
vim.keymap.set('n', '<leader>ce', '<cmd>CompetiTest edit_testcase<cr>', { desc = 'CP: edit testcase' })
vim.keymap.set('n', '<leader>ca', '<cmd>CompetiTest add_testcase<cr>', { desc = 'CP: add testcase' })

-- <leader>cS: submit the current solution to its judge.
-- The problem URL is read from the "// URL:" header that CompetiTest writes.
--   * Codeforces is behind Cloudflare, which blocks CLI submitters (oj/cf-tool
--     get 403). So for CF we copy the code to the clipboard and open the submit
--     page in the browser -- just Cmd+V and click Submit.
--   * Other judges (AtCoder, yukicoder, ...) have no such wall, so we use oj.
--     One-time login for those: `oj login <judge-url>`.
vim.keymap.set('n', '<leader>cS', function()
  local file = vim.fn.expand('%:p')
  local ft = vim.bo.filetype
  if ft ~= 'cpp' and ft ~= 'c' then
    vim.notify('CP submit: current buffer is not C/C++', vim.log.levels.WARN)
    return
  end
  local url
  for _, line in ipairs(vim.fn.readfile(file, '', 8)) do
    url = line:match('URL:%s*(https?://%S+)')
    if url then break end
  end
  if not url then
    vim.notify('CP submit: no "// URL:" line found in this file', vim.log.levels.ERROR)
    return
  end
  vim.cmd.write() -- save before submitting

  if url:match('codeforces%.com') then
    -- copy the solution to the macOS clipboard, then open the CF submit form
    local code = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
    vim.fn.system('pbcopy', code)
    local submit = url
      :gsub('/problemset/problem/(%d+)/(%w+)', '/problemset/submit/%1/%2')
      :gsub('/contest/(%d+)/problem/(%w+)', '/contest/%1/submit/%2')
      :gsub('/gym/(%d+)/problem/(%w+)', '/gym/%1/submit/%2')
    if vim.ui and vim.ui.open then vim.ui.open(submit) else vim.fn.system({ 'open', submit }) end
    vim.notify('Solution copied to clipboard — paste it into the CF submit page (Cmd+V)', vim.log.levels.INFO)
  else
    -- non-CF judge: submit through oj in a terminal split
    local oj_bin = vim.fn.expand('~/Library/Python/3.12/bin')
    local guess = (ft == 'cpp') and '--guess-cxx-latest ' or ''
    local cmd = string.format(
      'PATH=%s:$PATH oj submit %s%s %s',
      vim.fn.shellescape(oj_bin), guess, vim.fn.shellescape(url), vim.fn.shellescape(file)
    )
    vim.cmd('botright 15split | enew')
    vim.fn.termopen(cmd)
    vim.cmd.startinsert()
  end
end, { desc = 'CP: submit (CF: clipboard+browser; others: oj)' })

-- <leader>cd: drop the problem statement into <problem>.md and open it
-- side-by-side. First click the "CF statement" bookmarklet on the problem page
-- (see ~/.config/nvim/templates/cf-statement-bookmarklet.txt) to copy it.
vim.keymap.set('n', '<leader>cd', function()
  local src = vim.fn.expand('%:p')
  if src == '' then
    vim.notify('CP statement: no file in this buffer', vim.log.levels.WARN)
    return
  end
  local md = vim.fn.fnamemodify(src, ':r') .. '.md'
  local clip = vim.fn.system('pbpaste')
  if vim.v.shell_error ~= 0 or clip:gsub('%s', '') == '' then
    vim.notify('CP statement: clipboard is empty — run the CF bookmarklet first', vim.log.levels.ERROR)
    return
  end
  local f, err = io.open(md, 'w')
  if not f then
    vim.notify('CP statement: cannot write ' .. md .. ': ' .. tostring(err), vim.log.levels.ERROR)
    return
  end
  f:write(clip)
  f:close()
  vim.cmd('vsplit ' .. vim.fn.fnameescape(md))
  vim.wo.wrap = true
  vim.wo.linebreak = true
  vim.cmd('wincmd p') -- jump back to the solution
  vim.notify('Statement saved to ' .. vim.fn.fnamemodify(md, ':t'), vim.log.levels.INFO)
end, { desc = 'CP: statement -> .md side-by-side' })
