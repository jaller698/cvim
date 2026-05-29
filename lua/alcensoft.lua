-- Setup watchman to help LSPs to figure out file changes
require 'watchman'

-- SVN blame line
vim.api.nvim_create_user_command('SvnBlameLine', function()
  local filepath = vim.api.nvim_buf_get_name(0)

  if filepath == '' then
    vim.notify('No file name for current buffer.', vim.log.levels.WARN)
    return
  end

  local line_num = vim.api.nvim_win_get_cursor(0)[1]

  local blame_output = vim.fn.systemlist { 'svn', 'blame', filepath }

  if vim.v.shell_error ~= 0 then
    vim.notify('Error running svn blame:\n' .. table.concat(blame_output, '\n'), vim.log.levels.ERROR)
    return
  end

  local blame_line = blame_output[line_num]
  if not blame_line or blame_line == '' then
    vim.notify('No blame info found for line ' .. line_num, vim.log.levels.WARN)
    return
  end

  local revision = blame_line:match '^%s*(%d+)'

  if not revision then
    vim.notify('Could not parse revision (line might be uncommitted).', vim.log.levels.WARN)
    return
  end

  local log_output = vim.fn.systemlist { 'svn', 'log', '-r', revision, filepath }

  if vim.v.shell_error ~= 0 then
    vim.notify('Error running svn log:\n' .. table.concat(log_output, '\n'), vim.log.levels.ERROR)
    return
  end

  local comment_lines = {}
  local max_width = 0

  local header_info = log_output[2] or ('r' .. revision)

  for i = 4, #log_output - 1 do
    local line_text = log_output[i]
    table.insert(comment_lines, '  ' .. line_text .. '  ')

    local current_width = vim.fn.strdisplaywidth(line_text)
    if current_width > max_width then
      max_width = current_width
    end
  end

  if #comment_lines == 0 then
    table.insert(comment_lines, '  <No commit message>  ')
    max_width = 21
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, comment_lines)

  local width = math.max(max_width + 4, vim.fn.strdisplaywidth(header_info))
  local height = #comment_lines

  local max_win_height = math.floor(vim.o.lines * 0.4)
  if height > max_win_height then
    height = max_win_height
  end

  local opts = {
    relative = 'cursor',
    width = width,
    height = height,
    col = 0,
    row = 1,
    style = 'minimal',
    border = 'rounded',
    -- Use the SVN header (Revision | Author | Date) as the window title
    title = ' ' .. header_info:sub(1, width - 4) .. ' ',
    title_pos = 'center',
  }

  local win = vim.api.nvim_open_win(buf, false, opts)

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'InsertEnter' }, {
    buffer = 0,
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })
end, { desc = 'Show SVN commit comment for the current line' })

vim.keymap.set('n', '<leader>cb', ':SvnBlameLine<CR>', { noremap = true, silent = true, desc = 'See SVN blame on current line' })

return {
  {
    'juneedahamed/vc.vim',
  },
}
