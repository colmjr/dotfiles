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
  org_custom_exports = {
    t = {
      label = 'Export to PDF file (typst)',
      action = function(exporter)
        local current_file = vim.api.nvim_buf_get_name(0)
        local target = vim.fn.fnamemodify(current_file, ':p:r') .. '.pdf'
        return exporter({
          'pandoc',
          current_file,
          '-o',
          target,
          '--pdf-engine=typst',
          -- renders `#+begin_src typst` blocks as real typst instead of code listings
          '--lua-filter=' .. vim.fn.expand '~/.config/pandoc/filters/typst-src.lua',
          -- pandoc 3.10.1's builtin template errors on typst < 0.15 (horizontalRule typo)
          '--template=' .. vim.fn.expand '~/.config/pandoc/templates/typst.template',
        }, target)
      end,
    },
  },
  org_capture_templates = {
    n = {
      description = 'Notes',
      template = 'Notes: %? %t',
    },
    t = {
      description = 'Tasks',
      template = '* TODO %? %t',
      target = '~/org/todo.org',
    },
    r = {
      description = 'Refile',
      template = '* %? %t :refile:',
      target = '~/org/refile.org',
    },
    l = {
      description = 'Links',
      -- first 'blog' is the default; candidates (Tab-completable) start at the
      -- third part, so it's repeated to make it show up in completion too
      template = '* [[%x][%^{Description}]] %t :%^{Tag|blog|blog|article|tutorial|reddit|video|problem}:',
      target = '~/org/links.org',
      headline = function()
        local first = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ''
        return first:match ':problem:' and 'Problems' or 'Resources'
      end,
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
    -- markview sets conceallevel=3, which activates orgmode's link conceal;
    -- stock gx then can't see the url, so use orgmode's own opener instead
    vim.keymap.set('n', 'gx', function() require('orgmode').action 'org_mappings.open_at_point' end, { buffer = event.buf, desc = 'Open org link at point' })
  end,
})
