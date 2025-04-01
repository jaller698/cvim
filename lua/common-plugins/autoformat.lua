-- Function to remove extra trailing newlines
local function remove_extra_trailing_newlines()
        local line_count = vim.fn.line('$')
        while (line_count > 1) do
            local line_item = vim.fn.getline(line_count)
            -- print("line: ", line_count, "has: ", line_item)
            if (line_item:match("^$")) then
                local i = line_count - 1
                while vim.fn.getline(i):match("^$") do
                    vim.api.nvim_buf_set_lines(0, i - 1, i, false, {})
                    i = i - 1
                end
            end
            line_count = line_count-1
        end
    end

-- Create the autocmd using nvim_create_autocmd
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = function(ev)
                    remove_extra_trailing_newlines()
               end,
})

-- Remove trailing whitespace (https://vi.stackexchange.com/a/41388)
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = {"*"},
    callback = function(ev)
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

vim.api.nvim_create_user_command('DiffFormat', function()
  local ignore_filetypes = { "lua" }
  if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
    vim.notify("range formatting for " .. vim.bo.filetype .. " not working properly.")
    return
  end

  local hunks = require("gitsigns").get_hunks()
  if hunks == nil then
    return
  end

  local format = require("conform").format

  local function format_range()
    if next(hunks) == nil then
      vim.cmd('noautocmd w')
      vim.notify("done formatting git hunks", "info", { title = "formatting" })
      return
    end
    local hunk = nil
    while next(hunks) ~= nil and (hunk == nil or hunk.type == "delete") do
      hunk = table.remove(hunks)
    end

    if hunk ~= nil and hunk.type ~= "delete" then
      local start = hunk.added.start
      local last = start + hunk.added.count
      -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
      local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
      local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
      format({ range = range, async = true, lsp_fallback = true }, function()
        vim.defer_fn(function()
          format_range()
        end, 1)
      end)
    end
  end

  format_range()
end, { desc = 'Format changed lines' })

-- Setup the function to be used when saving
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*.cpp',
    callback = function (ev)
                    vim.cmd('DiffFormat')
               end
})

-- Lazy loads
return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>bf',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[B]uffer [F]ormat',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  },
}
