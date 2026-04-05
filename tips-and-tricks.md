# Tips & Tricks — Config Improvements and 0.11 → 0.12 Migration

This document covers actionable tips to improve this Neovim config, with a strong focus on changes needed when upgrading from Neovim **0.11** to **0.12**. Made by Copilot — verify against the official `:help news` for your installed version.

---

## Neovim 0.11 → 0.12 Migration

### 1. Replace `vim.loop` with `vim.uv`

`vim.loop` is an alias for `vim.uv` (libuv bindings) and is deprecated since 0.10. In 0.12 it may be removed.

**Affected file:** `lua/buffer-cleanup.lua`

```lua
-- Before (deprecated)
local cleanup_timer = vim.loop.new_timer()
local now = vim.loop.now()

-- After
local cleanup_timer = vim.uv.new_timer()
local now = vim.uv.now()
```

### 2. Replace deprecated `nvim_buf_get_option` / `nvim_buf_set_option`

`vim.api.nvim_buf_get_option` and `vim.api.nvim_buf_set_option` are deprecated. Use `vim.bo[buf]` (buffer-scoped options) instead.

**Affected file:** `lua/buffer-cleanup.lua`

```lua
-- Before (deprecated)
vim.api.nvim_buf_get_option(buf, 'modified')

-- After
vim.bo[buf].modified
```

Similarly replace `vim.api.nvim_win_get_option` with `vim.wo[win]`.

### 3. Simplify the `client_supports_method` compatibility shim

`lua/common-plugins/lspconfig.lua` contains a shim to handle the API difference between 0.10 and 0.11:

```lua
local function client_supports_method(client, method, bufnr)
  if vim.fn.has 'nvim-0.11' == 1 then
    return client:supports_method(method, bufnr)
  else
    return client.supports_method(method, { bufnr = bufnr })
  end
end
```

When dropping support for Neovim < 0.11, remove the shim entirely and call `client:supports_method(method, bufnr)` directly. In 0.12 this is the only supported form.

### 4. Migrate LSP setup to `vim.lsp.config` / `vim.lsp.enable`

Neovim 0.12 ships with a built-in `vim.lsp.config` that can replace much of `nvim-lspconfig` for straightforward servers. You can configure a server without any plugin:

```lua
-- In a file like lua/lsp/lua_ls.lua (or directly in settings):
vim.lsp.config('lua_ls', {
  settings = {
    Lua = { completion = { callSnippet = 'Replace' } },
  },
})
vim.lsp.enable('lua_ls')
```

`mason-lspconfig` already bridges Mason → `vim.lsp.config` via its handlers, so this is largely already done in the config. However, you can remove the `nvim-lspconfig` dependency for servers that need no special setup (e.g. `pyright`, `rust_analyzer`) once mason-lspconfig supports the new API fully.

> **Note:** The comment in `lspconfig.lua` that says `require('lspconfig')` is deprecated refers to calling `require('lspconfig').texlab.setup {}` directly. The handler approach already uses `vim.lsp.config` — this is the correct pattern for 0.12.

### 5. Switch from `nvim-cmp` to `blink.cmp` (recommended for 0.12)

`blink.cmp` is written in Rust and is significantly faster than `nvim-cmp`. It integrates natively with Neovim 0.11+/0.12's LSP client. Replace `lua/common-plugins/autocomplete.lua`:

```lua
return {
  'saghen/blink.cmp',
  version = '1.*',
  opts = {
    keymap = { preset = 'default' },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    completion = { documentation = { auto_show = true } },
  },
}
```

Remove `hrsh7th/nvim-cmp`, `hrsh7th/cmp-nvim-lsp`, `hrsh7th/cmp-path`, and `hrsh7th/cmp-nvim-lsp-signature-help`. Update `lspconfig.lua` to use `blink.cmp`'s capability helper:

```lua
local capabilities = require('blink.cmp').get_lsp_capabilities()
```

### 6. Use native LSP completion (lightweight alternative)

If you prefer zero extra plugins, Neovim 0.12 exposes `vim.lsp.completion` which can be attached per-buffer:

```lua
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
```

This works alongside or instead of `nvim-cmp`/`blink.cmp`.

### 7. Enable `vim.lsp.inlay_hint` globally (0.10+, improved in 0.12)

The current config enables inlay hints per-buffer on `LspAttach`. In 0.12 you can also enable them globally:

```lua
vim.lsp.inlay_hint.enable(true)
-- or toggle globally:
vim.keymap.set('n', '<leader>tH', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle Inlay Hints (global)' })
```

### 8. Use `vim.diagnostic.Opts` type annotations

Neovim 0.12 ships full LuaLS annotations for its public API. Add the type hint above the `vim.diagnostic.config` call in `lua/settings.lua` and `lua/common-plugins/lspconfig.lua` for auto-completion inside your config:

```lua
---@type vim.diagnostic.Opts
vim.diagnostic.config { ... }
```

### 9. Enable `vim.lsp.log` level management

In 0.12, `vim.lsp.set_log_level` is the recommended way to control LSP verbosity. During debugging:

```lua
vim.lsp.set_log_level('debug')  -- or 'warn' for production
```

View the log with `:lua vim.cmd('edit ' .. vim.lsp.get_log_path())`.

---

## General Config Improvements

### 10. Enable `friendly-snippets` for LuaSnip

The `autocomplete.lua` file has `friendly-snippets` commented out. Uncommenting it gives you hundreds of community-maintained snippets for free:

```lua
{
  'rafamadriz/friendly-snippets',
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()
  end,
},
```

### 11. Use `vim.schedule` for async-safe buffer cleanup

The cleanup timer in `buffer-cleanup.lua` already uses `vim.schedule_wrap`, which is correct. However, `vim.uv.now()` returns wall-clock milliseconds and is stable — prefer it to `os.clock()` or `os.time()` for measuring time deltas inside Neovim.

### 12. Replace `vim.fn.buflisted` with `vim.bo[buf].buflisted`

```lua
-- Before
vim.fn.buflisted(buf) == 1

-- After (idiomatic, returns boolean)
vim.bo[buf].buflisted
```

### 13. Add a `checkhealth` module

Create `lua/health.lua` to verify your config's external dependencies on startup:

```lua
local M = {}

function M.check()
  vim.health.start('cvim config')
  for _, tool in ipairs({ 'rg', 'fd', 'lazygit', 'stylua', 'yazi' }) do
    if vim.fn.executable(tool) == 1 then
      vim.health.ok(tool .. ' found')
    else
      vim.health.warn(tool .. ' not found — some features may be unavailable')
    end
  end
end

return M
```

Then run `:checkhealth cvim` to see a health report.

### 14. Consolidate duplicate `vim.diagnostic.config` calls

`lua/settings.lua` and `lua/common-plugins/lspconfig.lua` both call `vim.diagnostic.config`. These are merged at runtime but it is easy to introduce subtle conflicts. Keep a single authoritative call (e.g. only in `lspconfig.lua`) and remove the one in `settings.lua`.

### 15. Prefer `vim.keymap.set` over `vim.api.nvim_set_keymap`

`keymaps.lua` mixes both APIs. `vim.keymap.set` is the modern, Lua-native approach and accepts Lua functions directly. Replace the `nvim_set_keymap` calls in `keymaps.lua`:

```lua
-- Before
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })

-- After
vim.keymap.set('v', '<Tab>', '>gv', { desc = 'Indent selection' })
-- noremap = true is the default for vim.keymap.set
```

### 16. Add `desc` to all keymaps for `which-key` discoverability

Several keymaps in `keymaps.lua` lack a `desc` field. Adding descriptions improves `which-key` and `:map` output. Example for `<Tab>` / `<S-Tab>` in visual mode shown above.

### 17. Use `vim.opt` consistently instead of `:set` / `vim.cmd`

`init.lua` uses `vim.cmd('cd ' .. cwd)` to change directory. Prefer the Lua API:

```lua
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.fn.chdir(vim.fn.getcwd())
  end,
})
```

### 18. Leverage snacks.nvim scratch buffers for quick notes

`<leader>.` opens a scratch buffer, and `<leader>S` lets you select from multiple scratch buffers. These persist across restarts (stored in `stdpath('data')/snacks/scratch/`) and are great for temporary code snippets.

### 19. Use `Snacks.debug.inspect` (`dd()`) for Lua debugging

The config registers `_G.dd` as a global. Use it anywhere in your config to pretty-print Lua values without needing `:lua print(vim.inspect(...))`:

```lua
dd(vim.lsp.get_active_clients())   -- prints all active LSP clients
dd(vim.bo)                          -- inspect current buffer options
```

### 20. Profile startup with `:Lazy profile`

Run `:Lazy profile` to see load times per plugin. Target:
- Overall startup < 100 ms
- No plugin > 20 ms unless it is `priority = 1000` (e.g. snacks.nvim, colorscheme)

Plugins with unexpectedly high load times are candidates for `lazy = true` + `event`/`cmd`/`keys` triggers.

### 21. Enable treesitter folding (optional)

Treesitter folding provides semantic code folding. Add to `settings.lua`:

```lua
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = false  -- open all folds on file open
vim.opt.foldlevel = 99
```

Disable for large files using the `bigfile` feature already enabled in snacks.nvim.

### 22. Use `snacks.bigfile` to automatically tune large files

`snacks.nvim`'s `bigfile` feature is already enabled. It disables treesitter, LSP, and other expensive features for files over a configurable threshold (default ~1.5 MB). You can tune it:

```lua
bigfile = {
  enabled = true,
  size = 1024 * 512, -- 512 KB threshold
  setup = function(ctx)
    vim.cmd 'syntax clear'
    vim.opt_local.swapfile = false
  end,
},
```

### 23. Add `vim-signify` vs `gitsigns` — pick one

`init.lua` loads both `mhinz/vim-signify` and `lewis6991/gitsigns.nvim`. They both provide git diff signs in the sign column and will conflict. Remove `vim-signify` and keep `gitsigns` which has deeper Neovim integration (hunks as text objects, staging, blame, etc.).

### 24. Consider session management with `snacks.nvim`

`snacks.nvim` does not include session management, but the `<leader>fp` (projects picker) is a lightweight way to return to recent project directories. For full session restore (windows, buffers, cursor positions), consider adding `folke/persistence.nvim`:

```lua
{
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
  keys = {
    { '<leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
    { '<leader>qS', function() require('persistence').select() end, desc = 'Select Session' },
    { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restore Last Session' },
  },
}
```

### 25. Enable `render-markdown` for all markdown files

`init.lua` sets `ft = { 'markdown', 'md' }` for `render-markdown.nvim`. The correct Neovim filetype for `.md` files is `markdown` (not `md`). Remove the redundant `'md'` entry. You can verify with `:set filetype?` in a `.md` buffer.

---

## Quick Reference: Deprecated APIs to Update

| Deprecated (pre-0.12) | Replacement |
|---|---|
| `vim.loop.*` | `vim.uv.*` |
| `vim.api.nvim_buf_get_option(buf, opt)` | `vim.bo[buf][opt]` |
| `vim.api.nvim_buf_set_option(buf, opt, val)` | `vim.bo[buf][opt] = val` |
| `vim.api.nvim_win_get_option(win, opt)` | `vim.wo[win][opt]` |
| `vim.api.nvim_set_keymap(...)` | `vim.keymap.set(...)` |
| `client.supports_method(method, {bufnr=...})` | `client:supports_method(method, bufnr)` |
| `require('lspconfig').server.setup {}` | `vim.lsp.config('server', {}); vim.lsp.enable('server')` |

---

## Reading Material

- `:help news` — official changelog for the installed Neovim version
- `:help lsp-config` — built-in LSP config API (0.11+)
- `:help vim.uv` — libuv bindings
- `:help diagnostic-api` — full diagnostic configuration reference
- `<leader>N` — open Neovim news in a floating window (already mapped in this config)

---

**Last Updated:** 2026-04-05
