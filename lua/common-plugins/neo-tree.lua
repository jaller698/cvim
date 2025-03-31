
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    { '3rd/image.nvim', opts = {} },
  },
  lazy = false,
  opts = {
    commands = {
      system_open = function(state)
        vim.ui.open(state.tree:get_node():get_id())
      end,
    },
    window = { mappings = { O = "system_open" } },
    -- other options you might have
  },
  keys = {
    {
      '<leader>e',
      function()
        vim.cmd [[Neotree toggle]]
      end,
      mode = '',
      desc = 'N[E]otree toggle',
    },
  },
  config = function()
    -- Place your neo-tree related configuration here if needed

    -- Create an autocommand for neo-tree root changes:
    vim.api.nvim_create_autocmd("User", {
      pattern = "NeoTreeRootChanged",
      callback = function(args)
        if args.data and args.data.new_root then
          vim.cmd("lcd " .. args.data.new_root)
        end
      end,
    })
  end,
}

