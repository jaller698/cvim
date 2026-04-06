local M = {}

function M.check()
  vim.health.start 'cvim config'
  for _, tool in ipairs { 'rg', 'fd', 'lazygit', 'stylua', 'yazi' } do
    if vim.fn.executable(tool) == 1 then
      vim.health.ok(tool .. ' found')
    else
      vim.health.warn(tool .. ' not found — some features may be unavailable')
    end
  end
end

return M
