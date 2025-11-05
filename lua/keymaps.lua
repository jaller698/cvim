-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<Tab>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<S-Tab>', '<gv', { noremap = true, silent = true })

-- Resize splits with Ctrl + Arrow keys
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', { noremap = true, silent = true, desc = 'Increase window height' })
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', { noremap = true, silent = true, desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Right>', ':vertical resize -2<CR>', { noremap = true, silent = true, desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Left>', ':vertical resize +2<CR>', { noremap = true, silent = true, desc = 'Increase window width' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
vim.keymap.set('n', '<leader>dD', vim.diagnostic.setqflist, { desc = 'Show all diagnostics in quickfix' })

-- Quickfix navigation keymaps
vim.keymap.set('n', ']q', ':cnext<CR>', { noremap = true, silent = true, desc = 'Next quickfix item' })
vim.keymap.set('n', '[q', ':cprev<CR>', { noremap = true, silent = true, desc = 'Previous quickfix item' })
vim.keymap.set('n', ']Q', ':clast<CR>', { noremap = true, silent = true, desc = 'Last quickfix item' })
vim.keymap.set('n', '[Q', ':cfirst<CR>', { noremap = true, silent = true, desc = 'First quickfix item' })

-- Window management keymaps
vim.keymap.set('n', '<leader>wv', ':vsplit<CR>', { noremap = true, silent = true, desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>wh', ':split<CR>', { noremap = true, silent = true, desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>we', '<C-w>=', { noremap = true, silent = true, desc = 'Equalize window sizes' })
vim.keymap.set('n', '<leader>wm', ':only<CR>', { noremap = true, silent = true, desc = 'Maximize current window (close others)' })
vim.keymap.set('n', '<leader>wq', ':close<CR>', { noremap = true, silent = true, desc = 'Close current window' })

-- NOTE: Some terminals have coliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.keymap.set('n', '<leader>L', function()
  require('snacks').terminal.open('lynx https://tldr.tech/newsletters', {
    border = 'rounded',
    width = 0.9,
    height = 0.9,
  })
end, { desc = 'Open lynx in floating terminal' })

-- Show errors and warnings in a floating window
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = true, source = 'if_many' })
  end,
})

-- Configure diagnostics display
vim.diagnostic.config {
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN }, -- Only show warnings and errors
    source = 'if_many',
  },
  float = {
    source = 'if_many',
    border = 'rounded',
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}
