vim.keymap.set('n', '<leader>ca', function()
  require('tiny-code-action').code_action()
end, { noremap = true, silent = true, desc = 'View all code Actions' })

return {
  'rachartier/tiny-code-action.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim' },
    -- Picker via snacks
    {
      'folke/snacks.nvim',
      opts = {
        terminal = {},
      },
    },
  },
  event = 'LspAttach',
  opts = {},
}
