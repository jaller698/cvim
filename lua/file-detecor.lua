local filetypes = {
  ['*.tex'] = 'latex',
  ['*ockerfile*'] = 'dockerfile',
  ['*enkinsfile'] = 'groovy',
}

for pattern, ft in pairs(filetypes) do
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = pattern,
    callback = function()
      vim.bo.filetype = ft
    end,
  })
end
