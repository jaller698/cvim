return {
  {
    'gaborvecsei/usage-tracker.nvim',
    opts = {
      keep_eventlog_days = 14,
      cleanup_freq_days = 30,
      event_wait_period_in_sec = 5,
      inactivity_threshold_in_min = 5,
      inactivity_check_freq_in_sec = 5,
      verbose = 0,
      telemetry_endpoint = '', -- you'll need to start the restapi for this feature
    },
    event = 'VeryLazy',
    keys = {
      {
        '<leader>Ud',
        function()
          vim.cmd 'UsageTrackerShowDailyAggregation'
        end,
        desc = 'Usage Tracker: Daily aggregation',
      },
      {
        '<leader>Uf',
        function()
          vim.cmd 'UsageTrackerShowAgg filetype'
        end,
        desc = 'Usage Tracker: Show aggregation per filetype',
      },
      {
        '<leader>Up',
        function()
          vim.cmd 'UsageTrackerShowAgg project'
        end,
        desc = 'Usage Tracker: Show aggregation per project',
      },
    },
  },
  { 'QuentinGruber/timespent.nvim', keys = {
    { '<leader>Us', '<cmd>:ShowTimeSpent<cr>', mode = { 'n' }, desc = 'Show time spent' },
  } },
}
