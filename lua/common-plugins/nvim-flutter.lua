return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim', -- optional for vim.ui.select
  },
  config = true,
}
