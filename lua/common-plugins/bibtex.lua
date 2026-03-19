return {
  {
    'krissen/snacks-bibtex.nvim',
    dependencies = { 'folke/snacks.nvim' },
    opts = {
      -- optional overrides (see below)
      -- global_files = { "~/Documents/library.bib" },
    },
    keys = {
      {
        '<leader>dc',
        function()
          require('snacks-bibtex').bibtex()
        end,
        desc = 'BibTeX citations (Snacks)',
      },
    },
  },
}
