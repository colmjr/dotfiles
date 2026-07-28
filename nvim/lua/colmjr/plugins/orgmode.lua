vim.pack.add {
  { src = 'https://github.com/nvim-orgmode/orgmode' },
  { src = 'https://github.com/nvim-orgmode/telescope-orgmode.nvim' },
  { src = 'https://github.com/nvim-orgmode/org-bullets.nvim' },
}

require('orgmode').setup {
  org_agenda_files = '~/org/**/*',
  org_default_notes_file = '~/org/refile.org',
  org_adapt_indentation = false,
  org_todo_keywords = { 'TODO', 'IN-PROGRESS', '|', 'DONE' },
  org_capture_templates = {
    n = {
      description = 'Notes',
      template = 'Notes: %? %t',
    },
    r = {
      description = 'Repo',
      template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?",
      target = '~/org/repos.org',
    },
    l = {
      description = 'Links',
      template = '* [[%x][%^{Description}]] %t :%^{Tag|blog|article|tutorial|reddit|video|question}:',
      target = '~/org/links.org',
    },
  },
}
-- Experimental LSP support
vim.lsp.enable 'org'

require('org-bullets').setup()

-- Telescope may not be loaded yet here (plugin files load in unspecified order),
-- so access the extension lazily inside the keymaps; telescope auto-loads it on first use.
local function org_telescope(picker)
  return function() require('telescope').extensions.orgmode[picker]() end
end

vim.keymap.set('n', '<leader>so', org_telescope 'search_headings', { desc = '[S]earch [O]rg headings' })

-- Override orgmode's default refile and insert-link mappings with the Telescope versions
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'org',
  group = vim.api.nvim_create_augroup('orgmode-telescope', { clear = true }),
  callback = function(event)
    vim.keymap.set('n', '<leader>or', org_telescope 'refile_heading', { buffer = event.buf, desc = '[O]rg [R]efile heading' })
    vim.keymap.set('n', '<leader>oli', org_telescope 'insert_link', { buffer = event.buf, desc = '[O]rg insert [Li]nk' })
  end,
})
