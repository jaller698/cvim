return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    -- { '3rd/image.nvim', opts = {} },
  },
  lazy = false,
  opts = {
    commands = {
      system_open = function(state)
        vim.ui.open(state.tree:get_node():get_id())
      end,
    },
    default_component_configs = {
      name = { use_git_status_colors = true },
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
      modified = {
        symbol = '[+]',
        highlight = 'NeoTreeModified',
      },
      git_status = {
        symbols = {
          -- Change type
          added = '✚', -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = '✖', -- this can only be used in the git_status source
          renamed = '󰁕', -- this can only be used in the git_status source
          -- Status type
          untracked = '',
          ignored = '',
          unstaged = '󰄱',
          staged = '',
          conflict = '',
        },
      },

      window = {
        mappings = {
          O = 'system_open',
          ['P'] = {
            'toggle_preview',
            config = {
              use_float = false,
              -- use_image_nvim = true,
              -- title = 'Neo-tree Preview',
            },
          },
        },
      },
      event_handlers = {
        {
          event = 'file_opened',
          handler = function()
            require('neo-tree.command').execute { action = 'close' }
          end,
        },
      },
    },
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
    -- Update local working directory when neo-tree root changes.
    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '',
          [vim.diagnostic.severity.WARN] = '',
          [vim.diagnostic.severity.INFO] = '',
          [vim.diagnostic.severity.HINT] = '󰌵',
        },
      },
    }
    vim.api.nvim_create_autocmd('User', {
      pattern = 'NeoTreeRootChanged',
      callback = function(args)
        if args.data and args.data.new_root then
          vim.cmd('lcd ' .. args.data.new_root)
        end
      end,
    })

    -- Refresh neo-tree when exiting lazygit.
    vim.api.nvim_create_autocmd('TermClose', {
      pattern = '*lazygit*',
      callback = function()
        require('neo-tree.sources.filesystem.commands').refresh(require('neo-tree.sources.manager').get_state 'filesystem')
      end,
    })

    -- Ensure Neo-tree is the only window if opening with a directory argument.
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
          -- Capture the empty buffer ID before opening Neo-tree
          local empty_buf = vim.api.nvim_get_current_buf()

          -- Open Neo-tree and make it the only window
          vim.cmd 'Neotree show'
          vim.defer_fn(function()
            vim.cmd 'wincmd p' -- Move focus to Neo-tree
            vim.cmd 'only' -- Close all other windows

            -- If the empty buffer still exists, delete it properly
            if vim.api.nvim_buf_is_valid(empty_buf) then
              vim.cmd('bdelete! ' .. empty_buf) -- Force close the buffer without affecting windows
            end
          end, 100)
        end
      end,
    })
  end,
}
