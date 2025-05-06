if true then
  return {}
else
  return {
    'kevinhwang91/rnvimr',
    lazy = false,
    init = function()
      -- Global options
      vim.g.rnvimr_enable_ex = 1
      vim.g.rnvimr_enable_picker = 1
      vim.g.rnvimr_edit_cmd = 'drop'
      vim.g.rnvimr_draw_border = 0
      vim.g.rnvimr_hide_gitignore = 1
      vim.g.rnvimr_border_attr = { fg = 14, bg = -1 }
      vim.g.rnvimr_enable_bw = 1
      vim.g.rnvimr_shadow_winblend = 70
      vim.g.rnvimr_ranger_cmd = { 'ranger', '--cmd=set draw_borders both' }

      vim.g.rnvimr_action = {
        ['<C-t>'] = 'NvimEdit tabedit',
        ['<C-x>'] = 'NvimEdit split',
        ['<C-v>'] = 'NvimEdit vsplit',
        ['gw'] = 'JumpNvimCwd',
        ['yw'] = 'EmitRangerCwd',
      }

      -- Highlight
      vim.cmd [[highlight link RnvimrNormal CursorLine]]

      -- Keymaps
      vim.keymap.set('n', '<M-o>', ':RnvimrToggle<CR>', { silent = true })
      vim.keymap.set('t', '<M-o>', [[<C-\><C-n>:RnvimrToggle<CR>]], { silent = true })
      vim.keymap.set('t', '<M-i>', [[<C-\><C-n>:RnvimrResize<CR>]], { silent = true })
      vim.keymap.set('t', '<M-l>', [[<C-\><C-n>:RnvimrResize 1,8,9,11,5<CR>]], { silent = true })
      vim.keymap.set('t', '<M-y>', [[<C-\><C-n>:RnvimrResize 6<CR>]], { silent = true })
    end,
  }
end
