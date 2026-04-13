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
