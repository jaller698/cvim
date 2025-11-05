local buffer_access_times = {}

vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('buffer-cleanup', { clear = true }),
  callback = function(args)
    buffer_access_times[args.buf] = vim.loop.now()
  end,
})

local cleanup_timer = vim.loop.new_timer()
cleanup_timer:start(
  600000, -- Start after 10 minutes
  600000, -- Repeat every 10 minutes
  vim.schedule_wrap(function()
    local now = vim.loop.now()
    local max_age = 1800000 -- 30 minutes in milliseconds
    local buffers = vim.api.nvim_list_bufs()

    for _, buf in ipairs(buffers) do
      -- Only clean up hidden, unmodified buffers
      if vim.api.nvim_buf_is_valid(buf) and not vim.api.nvim_buf_get_option(buf, 'modified') and not vim.fn.buflisted(buf) then
        local last_access = buffer_access_times[buf] or 0
        if now - last_access > max_age then
          pcall(vim.api.nvim_buf_delete, buf, { force = false })
          buffer_access_times[buf] = nil
        end
      end
    end
  end)
)

-- Warn when too many buffers are open
vim.api.nvim_create_autocmd('BufAdd', {
  group = vim.api.nvim_create_augroup('buffer-limit-warning', { clear = true }),
  callback = function()
    local listed_buffers = vim.tbl_filter(function(buf)
      return vim.fn.buflisted(buf) == 1
    end, vim.api.nvim_list_bufs())

    if #listed_buffers > 20 then
      vim.notify('Warning: ' .. #listed_buffers .. ' buffers open. Consider closing some for better performance.', vim.log.levels.WARN)
    end
  end,
})
