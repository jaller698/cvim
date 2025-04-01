local function update_config()
  local last_update_file = vim.fn.stdpath "state" .. "/last_update_time" -- File to store last update time
  local current_time = os.time()
  local one_day_in_seconds = 24 * 60 * 60

  -- Check if the last update file exists and read the time
  local last_update_time = nil
  if vim.fn.filereadable(last_update_file) == 1 then
    local file = io.open(last_update_file, "r")
    if file then
      last_update_time = tonumber(file:read "*all")
      file:close()
    end
  end

  -- If the last update was more than a day ago, run the update
  if not last_update_time or (current_time - last_update_time) > one_day_in_seconds then
    -- Path to your local git repository
    local repo_path = vim.fn.stdpath "config" -- Assuming your config repo is the Neovim config directory

    -- Command to pull the latest changes
    local pull_command = { "git", "-C", repo_path, "pull" }

    -- Execute the command
    local result = vim.fn.systemlist(pull_command)

    -- Use vim.notify for notification
    if vim.v.shell_error == 0 then
      vim.notify "Configuration updated successfully!"

      -- Save the current time to the file as the last update time
      local file = io.open(last_update_file, "w")
      if file then
        file:write(tostring(current_time))
        file:close()
      end
    else
      vim.notify("Failed to update configuration!", vim.log.levels.ERROR)
      -- Optional: Show detailed error messages
      for _, line in ipairs(result) do
        vim.notify(line, vim.log.levels.ERROR)
      end
    end
  else
    vim.notify "Configuration already updated today."
  end
end

local function is_wsl()
  -- Check for the WSL_INTEROP environment variable
  if vim.fn.getenv("WSL_INTEROP") ~= vim.NIL then
    return true
  end

  -- Check for "microsoft" in the output of `uname -r`
  local uname = vim.fn.system("uname -r")
  if uname:lower():find("microsoft") then
    return true
  end

  return false
end

update_config()
