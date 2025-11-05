# Neovim Keymaps Reference

**Last Updated:** 2025-10-29

This document provides a comprehensive reference for the most important and custom keymaps in this Neovim configuration. The `<leader>` key is mapped to Space by default.

---

## General Navigation & Editing

| Keymap | Mode | Description |
|--------|------|-------------|
| `<C-h>` | Normal | Move focus to the left window |
| `<C-l>` | Normal | Move focus to the right window |
| `<C-j>` | Normal | Move focus to the lower window |
| `<C-k>` | Normal | Move focus to the upper window |
| `<C-Up>` | Normal | Decrease window height |
| `<C-Down>` | Normal | Increase window height |
| `<C-Left>` | Normal | Increase window width |
| `<C-Right>` | Normal | Decrease window width |
| `<Tab>` | Visual/Select | Indent selection |
| `<S-Tab>` | Visual/Select | Unindent selection |
| `<Esc><Esc>` | Terminal | Exit terminal mode |

---

## Buffer Management

| Keymap | Mode | Description |
|--------|------|-------------|
| `æ` | Normal | Cycle to previous buffer |
| `ø` | Normal | Cycle to next buffer |
| `<leader>bc` | Normal | Close current buffer (keeps window open) |
| `<leader>bq` | Normal | Quit window |
| `<leader>bp` | Normal | Pick a buffer interactively |
| `<leader>bl` | Normal | Close all buffers to the left |
| `<leader>br` | Normal | Close all buffers to the right |
| `<leader>ba` | Normal | Close all other buffers |
| `<leader>b\|` | Normal | Open last buffer in vertical split |
| `<leader>bh` | Normal | Open last buffer in horizontal split |

---

## File Navigation (Snacks Picker)

| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>ff` | Normal | Find files in current directory |
| `<leader>fg` | Normal | Find Git files |
| `<leader>fb` | Normal | Browse buffers |
| `<leader>fc` | Normal | Find config files |
| `<leader>fr` | Normal | Recent files |
| `<leader>fp` | Normal | Projects |
| `<leader>fw` | Normal | Find files by grep |
| `<leader>fe` | Normal | Open custom file picker |
| `<leader>e` | Normal/Visual | Open Yazi file manager |
| `<leader>cw` | Normal | Open Yazi in working directory |

---

## Search

| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>sb` | Normal | Search buffer lines |
| `<leader>sB` | Normal | Grep open buffers |
| `<leader>sw` | Normal | Grep workspace |
| `<leader>s/` | Normal | Search history |
| `<leader>sa` | Normal | Search autocmds |
| `<leader>sc` | Normal | Command history |
| `<leader>sC` | Normal | Commands |
| `<leader>sd` | Normal | Diagnostics |
| `<leader>sD` | Normal | Buffer diagnostics |

---

## Git Operations (Gitsigns & Snacks)

| Keymap | Mode | Description |
|--------|------|-------------|
| `]c` | Normal | Jump to next git change |
| `[c` | Normal | Jump to previous git change |
| `<leader>gs` | Normal | Stage hunk |
| `<leader>gs` | Visual | Stage selected hunk |
| `<leader>gr` | Normal | Reset hunk |
| `<leader>gr` | Visual | Reset selected hunk |
| `<leader>gS` | Normal | Stage buffer |
| `<leader>gu` | Normal | Undo stage hunk |
| `<leader>gR` | Normal | Reset buffer |
| `<leader>gp` | Normal | Preview hunk * |
| `<leader>gb` | Normal | Git branches * |
| `<leader>gd` | Normal | Git diff hunks * |
| `<leader>gD` | Normal | Git diff against HEAD * |
| `<leader>gg` | Normal | Open Lazygit |
| `<leader>gl` | Normal | Git log (Snacks) |
| `<leader>gL` | Normal | Git log line (Snacks) |
| `<leader>gf` | Normal | Git log file (Snacks) |
| `<leader>gS` | Normal | Git stash (Snacks) * |
| `<leader>tb` | Normal | Toggle git blame line |
| `<leader>tD` | Normal | Toggle git show deleted |

---

## LSP (Language Server Protocol)

| Keymap | Mode | Description |
|--------|------|-------------|
| `gD` | Normal | Go to declaration |
| `gd` | Normal | Go to definition (from telescope/snacks) |
| `gr` | Normal | Go to references |
| `gI` | Normal | Go to implementation |
| `<leader>cA` | Normal/Visual | Code action |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>dd` | Normal | Open diagnostic float |
| `<leader>dD` | Normal | Show all diagnostics in quickfix |
| `K` | Normal | Hover documentation |
| `<C-k>` | Insert | Signature help |

---

## Testing (Neotest)

Available in Python, Rust, C, and C++ files:

| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>dn` | Normal | Run nearest test |
| `<leader>df` | Normal | Run current file tests |
| `<leader>da` | Normal | Run all tests |
| `<leader>dw` | Normal | See test status/summary |
| `<leader>do` | Normal | Test output |
| `<leader>dO` | Normal | Test output panel |

---

## Terminal (ToggleTerm)

| Keymap | Mode | Description |
|--------|------|-------------|
| `<C-å>` | Normal | Toggle terminal (default mapping) |
| `<leader>th` | Normal | Toggle horizontal terminal |
| `<leader>tv` | Normal | Toggle vertical terminal |
| `<leader>tf` | Normal | Toggle floating terminal |
| `<leader>tnv` | Normal | New vertical terminal |
| `<leader>tnh` | Normal | New horizontal terminal |
| `<leader>tnf` | Normal | New floating terminal |
| `<leader>tq` | Normal | Toggle all terminals |
| `<leader>L` | Normal | Open lynx newsletter in floating terminal |

---

## Clipboard & Images

| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>p` | Normal | Paste image from system clipboard |

---

## Copilot & CodeCompanion

### Copilot (Insert Mode)

| Keymap | Mode | Description |
|--------|------|-------------|
| `<C-a>` | Insert | Accept Copilot suggestion |
| `<C-x>` | Insert | Dismiss Copilot suggestion |
| `<C-j>` | Insert | Next Copilot suggestion |
| `<C-k>` | Insert | Previous Copilot suggestion |
| `<C-l>` | Insert | Next word in Copilot suggestion |
| `<C-h>` | Insert | Previous word in Copilot suggestion |

### CodeCompanion

Commands:
- `:CodeCompanion` - Open CodeCompanion
- `:CodeCompanionChat` - Open CodeCompanion chat

---

## Flash (Quick Navigation)

| Keymap | Mode | Description |
|--------|------|-------------|
| `s` | Normal/Visual/Operator | Flash jump |
| `S` | Normal/Visual/Operator | Flash Treesitter |
| `r` | Operator | Remote Flash |
| `R` | Operator/Visual | Treesitter Search |
| `<C-s>` | Command | Toggle Flash Search |

---

## Autocompletion (nvim-cmp)

| Keymap | Mode | Description |
|--------|------|-------------|
| `<C-n>` | Insert | Next completion item |
| `<C-p>` | Insert | Previous completion item |
| `<C-b>` | Insert | Scroll docs backward |
| `<C-f>` | Insert | Scroll docs forward |
| `<CR>` | Insert | Confirm completion |

---

## Toggles & Utilities

| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>tb` | Normal | Toggle git blame line |
| `<leader>tD` | Normal | Toggle git show deleted |

---

## Additional Features

- **Highlight on Yank**: Text is briefly highlighted when copied (automatic)
- **Diagnostic Float on Cursor Hold**: Diagnostics automatically show when cursor is held on an error/warning
- **Working Directory Management**: Automatically sets working directory on startup
- **Keymap Conflicts**: Some keymaps marked with * may conflict between plugins (gitsigns vs Snacks). The Snacks keymaps typically override gitsigns since they're loaded later. Use `:map <leader>gX` to check which command is active for a specific key.

---

## Quickfix Navigation

| Keymap | Mode | Description |
|--------|------|-------------|
| `]q` | Normal | Next quickfix item |
| `[q` | Normal | Previous quickfix item |
| `]Q` | Normal | Last quickfix item |
| `[Q` | Normal | First quickfix item |

---

## Window Management

| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>wv` | Normal | Split window vertically |
| `<leader>wh` | Normal | Split window horizontally |
| `<leader>we` | Normal | Equalize window sizes |
| `<leader>wm` | Normal | Maximize current window (close others) |
| `<leader>wq` | Normal | Close current window |

---

## Key Prefix Groups

- `<leader>c` - **[C]ode** actions and operations
- `<leader>d` - **[D]ocument** / **[D]iagnostics** / **[D]ebug/Testing**
- `<leader>r` - **[R]ename** operations
- `<leader>f` - **[F]iles** and file operations
- `<leader>w` - **[W]orkspace** operations
- `<leader>t` - **[T]oggle** features
- `<leader>g` - **[G]it** operations
- `<leader>b` - **[B]uffers** management
- `<leader>s` - **[S]earch** operations
- `<leader>u` - **[U]tils** utilities
- `<leader>U` - **[U]sage** tracking
- `<leader>x` - **e[X]ecute** commands

---

## Notes

- Many keymaps are context-aware and only appear when appropriate (e.g., LSP keymaps only in buffers with LSP support)
- Use `:WhichKey` or press `<leader>` and wait to see available keymaps
- Special characters like `æ` and `ø` are used for buffer cycling (Norwegian keyboard layout)
- Some plugins may have additional keymaps not listed here - check plugin documentation for details
