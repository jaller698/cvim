require 'config-bootstrap'
require 'settings'
-- Set the working directory on startup
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    -- Use the current working directory at startup
    local cwd = vim.fn.getcwd()
    vim.cmd('cd ' .. cwd)
  end,
})

local function get_git_repo_name()
  local handle = io.popen 'git rev-parse --show-toplevel 2>/dev/null'
  if handle then
    local result = handle:read '*a'
    handle:close()
    if result then
      return vim.fn.fnamemodify(result:gsub('%s+$', ''), ':t')
    end
  end
  return nil
end

require 'lazy-bootstrap'
if vim.g.neovide then
  require 'neovide'
end
require 'keymaps'
require 'pdftex'
require 'file-detector'

vim.keymap.set('n', '<leader>fe', function()
  require('file-picker').open()
end, { desc = 'Open custom file picker' })

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
local plugins = {
  { import = 'common-plugins' },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
if get_git_repo_name() == 'DCI' then
  vim.list_extend(plugins, require 'dci')
end

-- NOTE: Here is where you install your plugins.
require('lazy').setup(plugins, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
