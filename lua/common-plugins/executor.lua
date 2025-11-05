return {
  'google/executor.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  cmd = { 'ExecutorOpen', 'ExecutorClose', 'ExecutorToggle' },
  config = function()
    -- your setup here
    require('executor').setup {
      use_split = false,
    }
  end,
  keys = {
    {
      '<leader>xe',
      function()
        require('executor').commands.run()
      end,
      desc = 'Execute code command (will use last command if not specified)',
    },
    {
      '<leader>xr',
      function()
        require('executor').commands.run_with_new_command()
      end,
      desc = 'Execute new code command and store for later',
    },
    {
      '<leader>xd',
      function()
        require('executor').commands.toggle_detail()
      end,
      desc = 'Show details of last command',
    },
    {
      '<leader>xh',
      function()
        require('executor').commands.show_history()
      end,
      desc = 'Show command history',
    },
  },
}
