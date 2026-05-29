return {
  {
    'zbirenbaum/copilot.lua',
    enabled = os.getenv 'NVIM_PROFILE' ~= 'work',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = '<C-a>',
            dismiss = '<C-x>',
            next = '<C-j>',
            prev = '<C-k>',
            accept_word = '<C-e>',
          },
        },
        panel = {
          enabled = true,
          auto_refresh = true,
        },
        filetypes = {
          markdown = true,
          help = true,
        },
        copilot_node_command = 'node', -- adjust if needed
        server_opts_overrides = {},
      }
    end,
  },
  {
    'milanglacier/minuet-ai.nvim',
    enabled = os.getenv 'NVIM_PROFILE' == 'work',
    event = 'InsertEnter',
    config = function()
      require('minuet').setup {
        -- Set LM Studio as the provider
        provider = 'openai_fim_compatible',
        n_completions = 1,
        context_window = 512,

        provider_options = {
          openai_fim_compatible = {
            api_key = 'NVIM_PROFILE',
            name = 'LM Studio',
            end_point = 'http://localhost:65533/v1/completions',
            model = 'google/gemma-4-e2b',
            optional = {
              max_tokens = 256,
              top_p = 0.9,
            },
          },
        },

        virtualtext = {
          -- Replaces auto_trigger = true & your filetypes table
          -- '*' means all filetypes, but you can restrict it to {'markdown', 'help'} if you prefer
          auto_trigger_ft = { '*' },
          auto_trigger_ignore_ft = {},

          keymap = {
            accept = '<C-a>',
            dismiss = '<C-x>',
            next = '<C-j>',
            prev = '<C-k>',
            accept_line = '<C-e>',
          },
        },
      }
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionChat' },
    enabled = os.getenv 'NVIM_PROFILE' ~= 'work',
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
        strategies = {
          chat = {
            adapter = 'gemini',
          },
          inline = {
            adapter = 'gemini',
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
