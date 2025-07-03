return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
    'alfaix/neotest-gtest',
    'rouge8/neotest-rust',
    'nvim-neotest/neotest-vim-test',
  },
  build = function()
    -- for example, install `cargo-nextest` if you want a nextest runner:
    vim.fn.system {
      'cargo',
      'install',
      'cargo-nextest',
      '--locked',
    }
  end,
  config = function(_, opts)
    -- 1) set up all your adapters
    opts.adapters = {
      require 'neotest-python' {
        dap = { justMyCode = false },
      },
      require('neotest-gtest').setup {},
      require 'neotest-rust',
      require 'neotest-vim-test' {
        ignore_file_types = { 'python', 'vim', 'lua' },
      },
    }

    -- 2) actually initialize neotest
    require('neotest').setup(opts)

    -- 3) now all of `require('neotest').run` etc. exist, so wire up your mappings
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'python', 'rust', 'c', 'cpp' },
      callback = function(args)
        -- require('neotest').watch.watch()
        local buf = args.buf
        local map = function(lhs, fn, desc)
          vim.keymap.set('n', lhs, fn, { buffer = buf, desc = desc })
        end

        map('<leader>df', function()
          require('neotest').run.run(vim.fn.expand '%')
        end, '🧪 Neotest: run current file')

        map('<leader>dn', function()
          require('neotest').run.run()
        end, '🧪 Neotest: run nearest test')

        map('<leader>da', function()
          require('neotest').run.run { suite = true }
        end, '🧪 Neotest: run all tests')

        map('<leader>dw', function()
          require('neotest').summary.toggle()
        end, '🧪 Neotest: See test status')

        map('<leader>do', function()
          require('neotest').output.open()
        end, '🧪 Neotest: Output')

        map('<leader>dO', function()
          require('neotest').output_panel.toggle()
        end, '🧪 Neotest: Output panel')
      end,
    })
  end,
}
