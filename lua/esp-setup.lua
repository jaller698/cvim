-- Create a user command to setup ESP-IDF environment
vim.api.nvim_create_user_command('EspSetup', function()
  local esp_dir = '/home/christian/Kode/Python/esp'
  local esp_install = esp_dir .. '/install.fish'
  local esp_export = esp_dir .. '/export.fish'
  local esp_targets = 'esp32,esp32s2,esp32s3'

  -- Check if the ESP scripts exist
  if vim.fn.filereadable(esp_install) ~= 1 then
    vim.notify('ESP install script not found: ' .. esp_install, vim.log.levels.ERROR)
    return
  end

  if vim.fn.filereadable(esp_export) ~= 1 then
    vim.notify('ESP export script not found: ' .. esp_export, vim.log.levels.ERROR)
    return
  end

  -- Show a notification that install is running (it might take a moment)
  vim.notify('Running ESP-IDF install for ' .. esp_targets .. '...', vim.log.levels.INFO)

  -- Build the command string (install first, then export)
  local install_cmd = string.format('%s %s', esp_install, esp_targets)
  local export_cmd = string.format('. %s', esp_export)
  local full_cmd = string.format('%s; and %s', install_cmd, export_cmd)

  -- Run the environment setup asynchronously
  vim.fn.jobstart(string.format('fish -c "%s; and env"', full_cmd), {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then
        return
      end

      vim.notify('ESP-IDF environment variables captured!', vim.log.levels.INFO)

      -- Parse and set environment variables
      for _, line in ipairs(data) do
        local key, value = line:match '^([^=]+)=(.*)$'
        if key and value then
          vim.fn.setenv(key, value)
        end
      end

      -- Now continue with the rest of the setup
      vim.schedule(function()
        -- Ensure compile_commands.json exists by running reconfigure if needed
        if vim.fn.filereadable 'build/compile_commands.json' ~= 1 then
          vim.notify('Generating compile_commands.json...', vim.log.levels.INFO)
          vim.fn.jobstart(string.format('fish -c "%s; and idf.py reconfigure"', full_cmd), {
            on_exit = function()
              vim.schedule(function()
                vim.notify('compile_commands.json generated!', vim.log.levels.INFO)
                setup_lsp()
              end)
            end,
          })
        else
          setup_lsp()
        end
      end)
    end,
    on_stderr = function(_, data)
      if data and #data > 0 and data[1] ~= '' then
        vim.notify('ESP-IDF setup warning: ' .. table.concat(data, '\n'), vim.log.levels.WARN)
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.schedule(function()
          vim.notify('ESP-IDF setup failed with code: ' .. code, vim.log.levels.ERROR)
        end)
      end
    end,
  })

  -- Function to setup LSP after environment is ready
  function setup_lsp()
    -- Create symlink to compile_commands.json if it doesn't exist
    if vim.fn.filereadable 'compile_commands.json' ~= 1 and vim.fn.filereadable 'build/compile_commands.json' == 1 then
      os.execute 'ln -sf build/compile_commands.json compile_commands.json'
    end

    -- Configure clangd to use esp32-clangd
    local has_esp32, esp32 = pcall(require, 'esp32')
    if not has_esp32 then
      vim.notify('esp32.nvim plugin not found!', vim.log.levels.ERROR)
      return
    end

    local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
    if not has_lspconfig then
      vim.notify('nvim-lspconfig not found!', vim.log.levels.ERROR)
      return
    end

    vim.notify('Configuring esp32-clangd...', vim.log.levels.INFO)

    -- Stop any running clangd instance
    local clients = vim.lsp.get_active_clients { name = 'clangd' }
    for _, client in ipairs(clients) do
      vim.lsp.stop_client(client.id)
    end

    -- Get esp32 clangd configuration
    local esp32_clangd_config = esp32.lsp_config()

    -- Setup clangd with esp32 configuration
    lspconfig.clangd.setup(esp32_clangd_config)

    vim.notify('Configured clangd to use esp32-clangd!', vim.log.levels.INFO)

    -- Restart clangd for current buffers
    vim.defer_fn(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
          if ft == 'c' or ft == 'cpp' then
            vim.api.nvim_buf_call(buf, function()
              vim.cmd 'LspStart clangd'
            end)
          end
        end
      end

      vim.notify('ESP-IDF environment and esp32-clangd LSP loaded!', vim.log.levels.INFO)
    end, 500)
  end

  -- Send command to ToggleTerm if it's available (do this immediately)
  local has_toggleterm, toggleterm = pcall(require, 'toggleterm')
  if has_toggleterm then
    -- Send to all open terminals
    local terminals = require('toggleterm.terminal').get_all()
    for _, term in pairs(terminals) do
      term:send(full_cmd, true)
    end

    -- Also set as default command for new terminals
    vim.g.toggleterm_startup_cmd = full_cmd

    vim.notify('Commands sent to ToggleTerm!', vim.log.levels.INFO)
  end
end, {
  desc = 'Run ESP-IDF install, setup environment, and configure esp32-clangd LSP',
})

-- Optional: Create an autocommand to run this when opening ESP-IDF projects
vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
  pattern = '*',
  callback = function()
    -- Check if this looks like an ESP-IDF project
    local esp_markers = {
      'sdkconfig',
      'CMakeLists.txt',
      'main/main.c',
      'main/main.cpp',
    }

    for _, marker in ipairs(esp_markers) do
      if vim.fn.filereadable(marker) == 1 then
        -- Uncomment the next line to auto-run on ESP-IDF project detection
        -- vim.cmd('EspSetup')
        break
      end
    end
  end,
})
