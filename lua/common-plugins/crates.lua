return {
  'saecki/crates.nvim',
  tag = 'stable',
  ft = 'toml',
  config = function()
    require('crates').setup()
  end,
}
