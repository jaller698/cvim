return {
  {
    'akinsho/toggleterm.nvim',
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
      direction = 'float',
    },
    keys = {
      { '<leader>th', '<cmd>ToggleTerm direction=horizontal<CR>', desc = 'Toggle horizontal terminal' },
      { '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>', desc = 'Toggle vertical terminal' },
    },
    config = function(_, opts)
      require('toggleterm').setup(opts)
    end,
  },
}
