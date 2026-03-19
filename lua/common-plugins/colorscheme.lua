return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }
    end,
  },
  {
    'sainnhe/everforest',

    -- Load the colorscheme here.
    config = function()
      vim.g.everforest_background = 'medium' -- Set the background style to 'medium' choose between 'hard', 'medium' or 'soft'
      vim.cmd.colorscheme 'everforest'
    end,
  },
  { 'protesilaos/tempus-themes-vim' },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'kepano/flexoki-neovim', name = 'flexoki' },
  { 'AlexvZyl/nordic.nvim', lazy = false, priority = 1000 },
  {

    'tiagovla/tokyodark.nvim',
    opts = {
      -- custom options here
    },
    config = function(_, opts)
      require('tokyodark').setup(opts) -- calling setup is optional
    end,
  },
  {
    'uhs-robert/oasis.nvim',
    lazy = false,
    priority = 1000,
  },
}
