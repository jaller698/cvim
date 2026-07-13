return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  enabled = false, -- Try and disable it and see if we need some time
  event = 'VeryLazy',
  dependencies = {
    -- 'nvim-lua/plenary.nvim',
    -- 'stevearc/dressing.nvim', -- optional for vim.ui.select
  },
  config = true,
}
