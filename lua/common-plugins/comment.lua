return {
  'numToStr/Comment.nvim',
  lazy = false,
  config = function()
    require('Comment').setup()

    -- Keymaps for <leader>/
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Normal mode: toggle current line comment
    map('n', '<leader>/', function()
      require('Comment.api').toggle.linewise.current()
    end, vim.tbl_extend('force', opts, { desc = 'Toggle comment on current line' }))

    -- Visual mode: toggle comment on selection
    map('v', '<leader>/', function()
      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
      vim.api.nvim_feedkeys(esc, 'x', false)
      require('Comment.api').toggle.linewise(vim.fn.visualmode())
    end, vim.tbl_extend('force', opts, { desc = 'Toggle comment on selection' }))
  end,
}
