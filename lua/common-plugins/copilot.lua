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
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = function()
      local is_work = os.getenv 'NVIM_PROFILE' == 'work'
      local active_adapter = is_work and 'lmstudio' or 'copilot'

      return {
        adapters = {
          http = {
            lmstudio = function()
              return require('codecompanion.adapters').extend('openai_compatible', {
                env = {
                  url = 'http://127.0.0.1:65533',
                  chat_url = '/v1/chat/completions',
                  api_key = 'lm-studio',
                },
              })
            end,
          },
        },
        strategies = {
          chat = {
            adapter = active_adapter,
          },
          inline = {
            adapter = active_adapter,
          },
          agent = {
            adapter = active_adapter,
          },
        },
        display = {
          action_palette = {
            width = 95,
            height = 10,
            prompt = 'Prompt ',
            provider = 'default',
            opts = {
              show_default_actions = true,
              show_default_prompt_library = true,
            },
          },
          chat = {
            icons = {
              buffer_pin = ' ',
              buffer_watch = '󰂥 ',
            },
            debug_window = {
              width = vim.o.columns - 5,
              height = vim.o.lines - 2,
            },
            window = {
              layout = 'vertical',
              position = nil,
              border = 'single',
              height = 0.8,
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
      }
    end,
  },
}
