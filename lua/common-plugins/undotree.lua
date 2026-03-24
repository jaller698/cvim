return {
  'mbbill/undotree',
  keys = {
    {
      '<leader>U',
      function()
        vim.cmd 'UndotreeToggle'
      end,
      desc = 'Toggle undotree',
    },
  },
}
