--- Local configuration only used when running from neovide

vim.o.guifont = 'Fira Code:h14'

vim.g.neovide_scale_factor = 1.0
vim.g.neovide_cursor_animation_length = 0

ResizeGuiFont = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
end

ResetGuiFont = function()
  vim.g.neovide_scale_factor = 1.0
end

-- Keymaps

local opts = { noremap = true, silent = true }

vim.keymap.set({ 'n', 'i' }, '<C-+>', function()
  ResizeGuiFont(0.1)
end, opts)
vim.keymap.set({ 'n', 'i' }, '<C-->', function()
  ResizeGuiFont(-0.1)
end, opts)
vim.keymap.set({ 'n', 'i' }, '<C-BS>', function()
  ResetGuiFont()
end, opts)

local function save()
  vim.cmd.write()
end
local function copy()
  vim.cmd [[normal! "+y]]
end
local function paste()
  vim.api.nvim_paste(vim.fn.getreg '+', true, -1)
end

vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', save, { desc = 'Save' })
vim.keymap.set('v', '<C-c>', copy, { silent = true, desc = 'Copy' })
vim.keymap.set({ 'n', 'i', 'v', 'c', 't' }, '<C-v>', paste, { silent = true, desc = 'Paste' })
