local M = {}

local current_dir = vim.fn.expand '%:p:h'
local preview_lines = 100 -- number of lines to preview

-- Define custom highlight groups for Git statuses
vim.api.nvim_set_hl(0, 'GitModified', { fg = '#E5C07B' }) -- yellow
vim.api.nvim_set_hl(0, 'GitAdded', { fg = '#98C379' }) -- green
vim.api.nvim_set_hl(0, 'GitDeleted', { fg = '#E06C75' }) -- red
vim.api.nvim_set_hl(0, 'GitUntracked', { fg = '#61AFEF' }) -- blue
vim.api.nvim_set_hl(0, 'FilePickerSelect', { bg = '#E22500' }) -- dark red background for selection

local select_ns = vim.api.nvim_create_namespace 'filepicker_select_ns'

-- Get git root for consistent relative paths
local function get_git_root(dir)
  local Job = require 'plenary.job'
  local root = dir
  Job:new({
    command = 'git',
    args = { '-C', dir, 'rev-parse', '--show-toplevel' },
    on_stdout = function(_, line)
      root = line
    end,
  }):sync()
  vim.inspect(root)
  return root
end

-- Cache git status info for the repo
local function get_git_status(repo_root)
  local Job = require 'plenary.job'
  local status = {}
  Job:new({
    command = 'git',
    args = { '-C', repo_root, 'status', '--porcelain' },
    on_stdout = function(_, line)
      local code = line:sub(1, 2)
      local path = line:sub(4)
      -- Normalize path
      status[path] = code
    end,
  }):sync()
  vim.inspect(status)
  return status
end

-- Render git icon based on status code
local function git_icon(code)
  if code:match 'M' then
    return ''
  end -- Modified
  if code:match 'A' then
    return ''
  end -- Added
  if code:match 'D' then
    return ''
  end -- Deleted
  if code == '??' then
    return ''
  end -- Untracked
  print('Unmatched code ' .. code)
  return ' ' -- Unmodified
end

-- Determine highlight group by status
local function hl_group(code)
  if code:match 'M' then
    return 'GitModified'
  end
  if code:match 'A' then
    return 'GitAdded'
  end
  if code:match 'D' then
    return 'GitDeleted'
  end
  if code == '??' then
    return 'GitUntracked'
  end
  return nil
end

-- Hide cursor by adjusting Cursor highlight blend on picker open
local function hide_cursor_on_open()
  local hl = vim.api.nvim_get_hl_by_name('Cursor', true)
  hl.blend = 100
  vim.api.nvim_set_hl(0, 'Cursor', hl)
  vim.opt.guicursor:append 'n-v-c:Cursor/lCursor'
end

-- Restore cursor on picker close
local function restore_cursor_on_close()
  local hl = vim.api.nvim_get_hl_by_name('Cursor', true)
  hl.blend = 0
  vim.api.nvim_set_hl(0, 'Cursor', hl)
  vim.opt.guicursor:remove 'n-v-c:Cursor/lCursor'
end

function M.open(dir)
  current_dir = dir or current_dir
  local entries = {}
  local entry_map = {}

  local repo_root = get_git_root(current_dir)
  if repo_root == nil then
    repo_root = current_dir
  end
  local git_status = get_git_status(repo_root)
  -- print('repo: ' .. repo_root .. ' status ')

  local handle = vim.loop.fs_scandir(current_dir)
  if handle then
    while true do
      local name, typ = vim.loop.fs_scandir_next(handle)
      if not name then
        break
      end
      local display = name .. (typ == 'directory' and '/' or '')
      local full_path = current_dir .. '/' .. name
      -- Compute path relative to repo root
      local rel_path = vim.fn.fnamemodify(full_path, ':.')
      rel_path = rel_path:gsub('^%./', '')
      -- Lookup git status
      local code = git_status[rel_path] or ''
      local line = git_icon(code) .. ' ' .. display
      table.insert(entries, line)
      entry_map[#entries] = { name = name, is_dir = (typ == 'directory'), code = code }
    end
  end

  -- create buffers
  local list_buf = vim.api.nvim_create_buf(false, true)
  local preview_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(list_buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(preview_buf, 'bufhidden', 'wipe')

  -- set initial list content
  vim.api.nvim_buf_set_lines(list_buf, 0, -1, false, entries)
  -- apply highlights per entry
  for i, entry in ipairs(entry_map) do
    local hl = hl_group(entry.code)
    if hl then
      vim.api.nvim_buf_add_highlight(list_buf, -1, hl, i - 1, 0, -1)
    end
  end

  -- layout calculations
  local total_width = math.floor(vim.o.columns * 0.8)
  local total_height = math.floor(vim.o.lines * 0.8)
  local list_width = math.floor(total_width * 0.3)
  local preview_width = total_width - list_width - 1
  local row = math.floor((vim.o.lines - total_height) / 2)
  local col = math.floor((vim.o.columns - total_width) / 2)

  -- hide cursor before opening
  hide_cursor_on_open()
  -- open floating windows
  local list_win = vim.api.nvim_open_win(list_buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = list_width,
    height = total_height,
    style = 'minimal',
    border = 'rounded',
  })
  vim.api.nvim_win_set_option(list_win, 'cursorline', true)
  vim.api.nvim_win_set_option(list_win, 'winblend', 0) -- only 10% transparent on cursorline

  local preview_win = vim.api.nvim_open_win(preview_buf, false, {
    relative = 'editor',
    row = row,
    col = col + list_width + 1,
    width = preview_width,
    height = total_height,
    style = 'minimal',
    border = 'rounded',
  })

  -- Treesitter attach on preview buffer
  vim.api.nvim_create_autocmd('BufWinEnter', {
    buffer = preview_buf,
    once = true,
    callback = function()
      vim.treesitter.start(preview_buf, vim.bo[preview_buf].filetype)
    end,
  })

  -- update preview & selection highlight
  vim.api.nvim_create_autocmd('CursorMoved', {
    buffer = list_buf,
    callback = function()
      local ln = vim.api.nvim_win_get_cursor(list_win)[1]
      -- clear previous
      vim.api.nvim_buf_clear_namespace(list_buf, select_ns, 0, -1)
      -- highlight current
      vim.api.nvim_buf_add_highlight(list_buf, select_ns, 'FilePickerSelect', ln - 1, 0, -1)

      local e = entry_map[ln]
      if e and not e.is_dir then
        local lines = vim.fn.readfile(current_dir .. '/' .. e.name)
        local slice = {}
        for i = 1, math.min(preview_lines, #lines) do
          slice[i] = lines[i]
        end
        vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, slice)
        vim.api.nvim_buf_set_option(preview_buf, 'filetype', vim.fn.fnamemodify(e.name, ':e'))
        vim.api.nvim_buf_call(preview_buf, function()
          vim.cmd 'silent! TSBufEnable highlight'
        end)
      else
        vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, {})
      end
    end,
  })

  -- keymaps
  local function close_all()
    vim.api.nvim_win_close(list_win, true)
    vim.api.nvim_win_close(preview_win, true)
    restore_cursor_on_close()
  end
  vim.keymap.set('n', 'q', close_all, { buffer = list_buf })
  vim.keymap.set('n', '<CR>', function()
    local ln = vim.api.nvim_win_get_cursor(list_win)[1]
    local e = entry_map[ln]
    if not e then
      return
    end
    local target = current_dir .. '/' .. e.name
    close_all()
    if e.is_dir then
      M.open(target)
    else
      vim.cmd('edit ' .. vim.fn.fnameescape(target))
    end
  end, { buffer = list_buf })
  vim.keymap.set('n', '<BS>', function()
    close_all()
    M.open(vim.fn.fnamemodify(current_dir, ':h'))
  end, { buffer = list_buf })

  -- Additional keymaps for file operations (to be placed inside your M.open keymap section)

  -- Create a new file (and any necessary parent directories)
  vim.keymap.set('n', 'a', function()
    vim.ui.input({ prompt = 'New file name: ', default = '' }, function(input)
      if not input or #input == 0 then
        return
      end
      local full = current_dir .. '/' .. input
      -- create parent dirs if needed
      vim.fn.mkdir(vim.fn.fnamemodify(full, ':h'), 'p')
      -- create the file
      vim.fn.writefile({}, full)
      -- refresh the picker
      M.open(current_dir)
    end)
  end, { buffer = list_buf })

  -- Create a new directory
  vim.keymap.set('n', 'A', function()
    vim.ui.input({ prompt = 'New directory name: ', default = '' }, function(input)
      if not input or #input == 0 then
        return
      end
      local full = current_dir .. '/' .. input
      vim.fn.mkdir(full, 'p')
      M.open(current_dir)
    end)
  end, { buffer = list_buf })

  -- Delete the selected file or directory
  vim.keymap.set('n', 'd', function()
    local ln = vim.api.nvim_win_get_cursor(list_win)[1]
    local e = entry_map[ln]
    if not e then
      return
    end
    local full = current_dir .. '/' .. e.name
    vim.ui.input({ prompt = 'Delete "' .. e.name .. '"? (y/n): ' }, function(confirm)
      if confirm and confirm:lower() == 'y' then
        if e.is_dir then
          vim.fn.delete(full, 'rf')
        else
          vim.fn.delete(full)
        end
        M.open(current_dir)
      end
    end)
  end, { buffer = list_buf })

  -- Rename the selected file or directory
  vim.keymap.set('n', 'r', function()
    local ln = vim.api.nvim_win_get_cursor(list_win)[1]
    local e = entry_map[ln]
    if not e then
      return
    end
    local old = current_dir .. '/' .. e.name
    vim.ui.input({ prompt = 'Rename "' .. e.name .. '" to: ', default = e.name }, function(newname)
      if newname and #newname > 0 and newname ~= e.name then
        local newpath = current_dir .. '/' .. newname
        vim.fn.rename(old, newpath)
        M.open(current_dir)
      end
    end)
  end, { buffer = list_buf })
end

return M
