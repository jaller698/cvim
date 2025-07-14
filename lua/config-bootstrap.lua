local function update_config()
  local state_dir = vim.fn.stdpath 'state'
  local last_update_file = state_dir .. '/last_update_time'
  local current_time = os.time()
  local one_day = 24 * 60 * 60

  local last_update_time
  if vim.fn.filereadable(last_update_file) == 1 then
    local content = vim.fn.readfile(last_update_file)
    last_update_time = tonumber(content[1])
  end

  if not last_update_time or (current_time - last_update_time) > one_day then
    local repo_path = vim.fn.stdpath 'config'
    local result = vim.fn.systemlist { 'git', '-C', repo_path, 'pull' }
    if vim.v.shell_error == 0 then
      vim.notify('Configuration updated successfully!', vim.log.levels.INFO)
      vim.fn.writefile({ tostring(current_time) }, last_update_file)
    else
      vim.notify('Failed to update configuration!', vim.log.levels.ERROR)
      for _, line in ipairs(result) do
        vim.notify(line, vim.log.levels.ERROR)
      end
    end
  else
    vim.notify('Configuration already updated today.', vim.log.levels.INFO)
  end
end

update_config()

local function is_wsl()
  if os.getenv 'WSL_INTEROP' then
    return true
  end
  local uname = vim.fn.system 'uname -r'
  return uname:lower():find 'microsoft' ~= nil
end
