vim.keymap.set('n', '<leader>ca', function()
  require('tiny-code-action').code_action()
end, { noremap = true, silent = true, desc = 'View all code Actions' })

-- Add code_action as an entry in the pop up menu
vim.api.nvim_create_user_command('TinyCodeAction', function()
  require('tiny-code-action').code_action()
end, {})
vim.cmd [[amenu PopUp.Code\ Action :TinyCodeAction<CR>]]

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
