return {
  'jaller698/lazy-svn',
  build = 'cargo build --release',
  dependencies = {
    'folke/snacks.nvim',
  },
  keys = {
    { '<leader>sv', '<cmd>LazySVN<cr>', desc = 'Open lazySVN' },
  },
  config = true,
}
