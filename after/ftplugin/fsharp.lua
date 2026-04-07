-- Disable semantic tokens for fsautocomplete to avoid freezes on large F# files (HACK)

local group = vim.api.nvim_create_augroup('fsharp-disable-semantic-tokens', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  buffer = 0,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'fsautocomplete' then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})
