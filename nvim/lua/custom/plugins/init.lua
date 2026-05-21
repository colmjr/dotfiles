-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Iterate over all Lua files in the plugins directory and load them
local function gh(repo) return 'https://github.com/' .. repo end

local function pack_add(specs, opts)
  local original_wait = vim.wait
  vim.wait = function(timeout, callback, interval, fast_only)
    if timeout == 30000 then timeout = vim.g.pack_install_timeout_ms or 120000 end
    return original_wait(timeout, callback, interval, fast_only)
  end
  local ok, err = pcall(vim.pack.add, specs, opts)
  vim.wait = original_wait
  if not ok then error(err, 2) end
end

-- - pack_add { gh 'NeogitOrg/neogit' }
-- require('neogit').setup {}
--
-- vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<CR>', { desc = 'Neogit' })
pack_add { gh 'tpope/vim-fugitive' }
pack_add { gh 'sphamba/smear-cursor.nvim' }
require('smear_cursor').setup {
  stiffness = 0.9,
  trailing_stiffness = 0.5,
  distance_stop_animating = 0.5,
  smear_between_buffers = true,
  smear_between_neighbor_lines = true,
  legacy_computing_symbols_support = true,
  smear_insert_mode = true,
}

local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'custom', 'plugins')
for file_name, type in vim.fs.dir(plugins_dir) do
  if type == 'file' and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('custom.plugins.' .. module)
  end
end
