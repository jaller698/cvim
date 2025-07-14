return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function(_, opts)
      -- Set the copilot config options here
      --  Setup the copilot to complete using C-a
      vim.g.copilot_no_tab_map = true
      -- Accept suggestion
      vim.keymap.set('i', '<C-a>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = 'Copilot Accept',
      })
      -- Dismiss suggestion
      vim.keymap.set('i', '<C-x>', 'copilot#Dismiss()', {
        expr = true,
        replace_keycodes = false,
        desc = 'Copilot Dismiss',
      })
      -- Next suggestion
      vim.keymap.set('i', '<C-j>', 'copilot#Next()', {
        expr = true,
        replace_keycodes = false,
        desc = 'Copilot Next',
      })
      -- Previous suggestion
      vim.keymap.set('i', '<C-k>', 'copilot#Previous()', {
        expr = true,
        replace_keycodes = false,
        desc = 'Copilot Previous',
      })
      -- Next word in suggestion
      vim.keymap.set('i', '<C-l>', 'copilot#NextWord()', {
        expr = true,
        replace_keycodes = false,
        desc = 'Copilot Next Word',
      })
      -- Previous word in suggestion
      vim.keymap.set('i', '<C-h>', 'copilot#PreviousWord()', {
        expr = true,
        replace_keycodes = false,
        desc = 'Copilot Previous Word',
      })
      vim.g.copilot_workspace_folders = '~/code/dci/'
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionChat' },
    opts = {
      strategies = {
        chat = {
          variables = {
            ['git_diff'] = {
              callback = function()
                return vim.fn.system 'git diff --cached origin/master'
              end,
              description = 'Git Diff',
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = 'Prompt ', -- Prompt used for interactive LLM calls
          provider = providers and providers.action_palette or 'default', -- telescope|mini_pick|snacks|default
          opts = {
            show_default_actions = true, -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
          },
        },
        chat = {
          icons = {
            buffer_pin = ' ',
            buffer_watch = '󰂥 ',
          },
          debug_window = {
            ---@return number|fun(): number
            width = vim.o.columns - 5,
            ---@return number|fun(): number
            height = vim.o.lines - 2,
          },
          window = {
            layout = 'vertical', -- float|vertical|horizontal|buffer
            position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
            border = 'single',
            height = 0.8,
            ---@type number|"auto" using "auto" will allow full_height buffers to act like normal buffers
            width = 0.30,
            relative = 'editor',
            full_height = true,
            opts = {
              breakindent = true,
              cursorcolumn = false,
              cursorline = false,
              foldcolumn = '0',
              linebreak = true,
              list = false,
              numberwidth = 1,
              signcolumn = 'no',
              spell = false,
              wrap = true,
            },
          },
        },
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },
}
