-- Setup watchman to help LSPs to figure out file changes
require 'watchman'

return { {
  'juneedahamed/svnj.vim',
}, {
  'sainnhe/everforest',
  config = function()
    vim.cmd.colorscheme 'everforest'
  end,
} }
