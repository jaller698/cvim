return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  build = ':TSUpdate',
  lazy = false,
  opts = {
    ensure_installed = {
      'all',
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    -- Redundant in neovim 0.12
    -- require('nvim-treesitter.configs').setup(opts)

    local group = vim.api.nvim_create_augroup('AlwaysStartTreesitter', { clear = true })

    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      pattern = '*',
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang and vim.treesitter.language.add(lang) then
          vim.treesitter.start()
        end
      end,
    })
  end,
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  -- config = function()
  --   local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
  --   require('nvim-treesitter.install').prefer_git = true
  --
  --   parser_config.spade = {
  --     install_info = {
  --       url = 'https://gitlab.com/spade-lang/tree-sitter-spade/', -- local path or git repo
  --       files = { 'src/parser.c' },
  --       -- optional entries:
  --       branch = 'main', -- default branch in case of git repo if different from master
  --       generate_requires_npm = false, -- if stand-alone parser without npm dependencies
  --       requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  --     },
  --     filetype = 'spade', -- if filetype does not match the parser name
  --   }
  -- end,
}
