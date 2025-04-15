---@class snacks.tui_newsletter.Config: snacks.terminal.Opts
---@field command? string A shell command to run your TUI newsletter binary.

local M = {}

-- Helper: returns our default configuration.
local function default_config()
  local cache_dir = vim.fn.stdpath 'cache' .. '/'
  local default_cmd = cache_dir .. 'tui_newsletter/target/release/rusty_tldr'
  return {
    command = default_cmd,
    width = 0.6, -- 60% of the editor width
    height = 0.6, -- 60% of the editor height
    wo = {
      spell = false,
      wrap = false,
      signcolumn = 'yes',
      statuscolumn = ' ',
      conceallevel = 3,
    },
    win = {
      style = 'tui_newsletter',
    },
  }
end

--- Clones the repository and compiles the TUI newsletter binary.
--- @return boolean true if compilation succeeded, false otherwise.
function M.setup()
  local cache_dir = vim.fn.stdpath 'cache' .. '/tui_newsletter'
  local repo_url = 'git@github.com:jaller698/rusty_tldr.git'

  if vim.fn.isdirectory(cache_dir) == 0 then
    vim.notify('Cloning tui_newsletter repository...', vim.log.levels.INFO)
    local clone_cmd = string.format('git clone %s %s', repo_url, cache_dir)
    vim.fn.system(clone_cmd)
  else
    vim.notify('Repository already cloned.', vim.log.levels.INFO)
  end

  vim.notify('Compiling tui_newsletter...', vim.log.levels.INFO)
  local build_cmd = string.format('cd %s && cargo build --release', cache_dir)
  local out = vim.fn.system(build_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to compile tui_newsletter:\n' .. out, vim.log.levels.ERROR)
    return false
  else
    vim.notify('tui_newsletter compiled successfully.', vim.log.levels.INFO)
    return true
  end
end

--- Opens the TUI newsletter binary in a floating terminal window.
--- @param opts? snacks.tui_newsletter.Config optional overrides for configuration
function M.open(opts)
  opts = vim.tbl_deep_extend('force', default_config(), opts or {})
  -- Snacks.terminal expects a command (as a table) and options.
  return Snacks.terminal({ opts.command }, opts)
end

return M
