return {
  'saghen/blink.cmp',
  build = 'cargo build --release',
  version = '1.*',
  opts = {
    cmdline = {
      enabled = false,
    },
    keymap = {
      -- set to 'none' to disable the 'default' preset
      preset = 'default',

      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },

      -- Accept currently selected item.
      ['<C-Y>'] = { 'accept', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },

      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },

      -- Force the completion menu to show, even if there is only one match
      -- ['<C-Space>'] = { 'complete' },

      -- show with a list of providers
      ['<C-space>'] = {
        function(cmp)
          cmp.show { providers = { 'snippets' } }
        end,
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    completion = {
      documentation = { auto_show = true },
    },
  },
}
