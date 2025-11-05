return {
  {
    'akinsho/toggleterm.nvim',
    cmd = { 'ToggleTerm', 'TermNew', 'TermExec', 'ToggleTermToggleAll' },
    opts = {
      open_mapping = [[<c-å>]], -- Default mapping to toggle terminal; feel free to change or remove
      size = function(term)
        if term.direction == 'vertical' then
          return math.floor(vim.o.columns * 0.4)
        else
          return 15
        end
      end,
      -- You can set your default direction here, though our mappings will override it:
      direction = 'vertical',
    },
    keys = {
      { '<leader>th', '<cmd>ToggleTerm direction=horizontal<CR>', desc = 'Toggle horizontal terminal' },
      { '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>', desc = 'Toggle vertical terminal' },
      { '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', desc = 'Toggle floating terminal' },
      { '<leader>tnv', '<cmd>TermNew direction=vertical<CR>', desc = 'New vertical terminal' },
      { '<leader>tnh', '<cmd>TermNew direction=horizontal<CR>', desc = 'New horizontal terminal' },
      { '<leader>tnf', '<cmd>TermNew direction=float<CR>', desc = 'New floating terminal' },
      { '<leader>tq', '<cmd>ToggleTermToggleAll<CR>', desc = 'Toggle all terminals' },
    },
    config = function(_, opts)
      if vim.fn.has 'win32' == 1 then
        opts.shell = 'powershell'
      end
      require('toggleterm').setup(opts)
    end,
  },
}
