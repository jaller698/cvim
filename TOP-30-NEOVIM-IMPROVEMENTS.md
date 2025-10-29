# Top 30 Neovim Configuration Improvements

This document outlines 30 high-impact improvements for this Neovim configuration, focused on **speed**, **efficiency**, and **maintainability**. Each item is actionable and designed to enhance the overall development experience.

---

## Performance & Speed Optimization

- [ ] **1. Lazy-load more plugins by event/filetype**
  - Review all plugins in `lua/common-plugins/` and ensure they use `lazy = true`, `event`, `ft`, `cmd`, or `keys` to defer loading until actually needed
  - Benchmark startup time with `:Lazy profile` to identify slow-loading plugins

- [ ] **2. Enable persistent undo with size limits**
  - Add `vim.opt.undofile = true` in settings.lua to persist undo history across sessions
  - Set `vim.opt.undolevels = 10000` and `vim.opt.undoreload = 10000` for practical limits
  - Configure `vim.opt.undodir` to a dedicated directory with automatic cleanup

- [ ] **3. Optimize LSP server startup**
  - Configure LSP servers to start only when needed using `on_attach` callbacks
  - Consider using `null-ls` or `none-ls` alternatives for lighter formatting/linting
  - Disable unused LSP features per language server to reduce overhead

- [ ] **4. Implement smart buffer cleanup**
  - Create autocommand to automatically close hidden buffers after N minutes of inactivity
  - Add buffer count limit warning when too many buffers are open
  - Implement LRU (Least Recently Used) buffer cleanup strategy

- [ ] **5. Cache file type detection**
  - Enable `vim.g.do_filetype_lua = 1` for faster filetype detection
  - Review and optimize custom filetype patterns in `file-detector.lua`
  - Consider pre-loading common filetypes

- [ ] **6. Optimize treesitter parsing**
  - Configure `incremental_selection` and `indent` modules only for needed languages
  - Disable treesitter for very large files (>1MB) automatically
  - Use `vim.opt.foldmethod = "expr"` with treesitter fold expression for better fold performance

---

## Workflow Efficiency

- [ ] **7. Add project-local configuration support**
  - Implement `.nvim.lua` or `.nvimrc` loading in project root with security checks
  - Allow per-project LSP, formatting, and linting overrides
  - Document the configuration format and security considerations

- [ ] **8. Create custom snippets collection**
  - Build language-specific snippet collections in LuaSnip format
  - Include common patterns for each supported language (Python, Rust, C++, etc.)
  - Add dynamic snippets that adapt to context (class, function, etc.)

- [ ] **9. Implement session management**
  - Add automatic session save/restore on directory basis
  - Configure session to remember open buffers, window layout, and working directory
  - Consider plugins like `auto-session`, `possession.nvim`, or implement custom Lua-based solution with `mksession`

- [ ] **10. Enhanced quickfix/location list workflow**
  - Add keymaps for quickly navigating quickfix items (`]q`, `[q`)
  - Implement auto-open quickfix when items are added (LSP diagnostics, search results)
  - Add commands to filter/sort quickfix list entries

- [ ] **11. Improved markdown editing experience**
  - Enable live preview for markdown files (glow, markdown-preview.nvim)
  - Add table formatting keybindings
  - Configure smart lists and checkbox toggling
  - Integrate with Zettelkasten or note-taking workflow

- [ ] **12. Keyboard-driven window management**
  - Add keymaps for window splitting with preset ratios
  - Implement window resizing presets (80 columns for code, 120 for docs)
  - Add "zoom" functionality to temporarily maximize current window

---

## Code Quality & Development

- [ ] **13. Integrate additional linters per language**
  - Add mypy for Python (static type checking)
  - Add clippy for Rust (comprehensive linting)
  - Add cppcheck for C/C++ (static analysis)
  - Configure formatters to run on save with `autoformat.lua`

- [ ] **14. Set up debugging configurations**
  - Complete DAP (Debug Adapter Protocol) setup for all supported languages
  - Create language-specific launch configurations
  - Add conditional breakpoint support and log points
  - Document debugging workflows in keymaps.md

- [ ] **15. Enhance git integration**
  - Add git conflict resolution keymaps and highlighting
  - Integrate `git-worktree` for managing multiple branches
  - Add commit message templates and conventional commits support
  - Configure git hooks for pre-commit linting

- [ ] **16. Implement code refactoring helpers**
  - Add keybindings for common refactorings (extract function, rename, inline)
  - Integrate with language-specific refactoring tools
  - Create custom refactoring snippets for common patterns

- [ ] **17. Better error handling and diagnostics display**
  - Configure diagnostic virtual text to show only on current line
  - Add severity-based highlighting (error vs warning vs hint)
  - Implement diagnostic filtering by severity or source
  - Add keymaps to cycle through diagnostics efficiently

- [ ] **18. Test coverage visualization**
  - Integrate test coverage tools (coverage.py for Python, tarpaulin for Rust)
  - Display coverage inline with signs/virtual text
  - Add commands to run tests with coverage and view reports
  - Configure coverage thresholds and warnings

---

## Maintainability & Organization

- [ ] **19. Modularize plugin configurations**
  - Split large plugin configs (e.g., lspconfig.lua) into smaller files per language
  - Create `lua/config/` directory for non-plugin settings
  - Implement consistent configuration structure across all plugins

- [ ] **20. Document custom functions and utilities**
  - Add LuaLS type annotations to all custom Lua functions
  - Create `docs/` directory with development guides
  - Document the purpose and configuration of each plugin
  - Add inline comments for complex logic

- [ ] **21. Implement health check system**
  - Create custom health checks for project-specific requirements (`:checkhealth custom`)
  - Verify external dependencies (ripgrep, fd, lazygit) are installed
  - Check for conflicting configurations or deprecated options
  - Add custom health check module for this configuration

- [ ] **22. Version control for configuration**
  - Add `.git-blame-ignore-revs` for formatting commits
  - Create changelog tracking configuration improvements
  - Tag stable configuration versions
  - Document breaking changes and migration paths

- [ ] **23. Create configuration profiles**
  - Implement light/heavy profiles for different machine capabilities
  - Add minimal profile for remote/SSH editing
  - Create language-specific profiles (Python-focused, Rust-focused, etc.)
  - Allow easy profile switching via environment variable or command

- [ ] **24. Standardize keymap organization**
  - Review all keymaps for consistency and conflicts
  - Document keymap philosophy (why certain keys were chosen)
  - Create keymap categories that don't overlap
  - Add `which-key` descriptions for all custom keymaps

---

## User Experience

- [ ] **25. Improve startup screen**
  - Customize dashboard with useful shortcuts and recent projects
  - Add inspirational quotes or tips for Neovim usage
  - Display configuration health status on startup
  - Show recently used files and quick actions

- [ ] **26. Enhanced statusline/winbar information**
  - Show LSP server status and active formatters
  - Display current git branch and dirty state
  - Add macro recording indicator
  - Show current search match count
  - Display current mode with custom colors

- [ ] **27. Better notification system**
  - Configure notification timeouts based on severity
  - Add notification history viewer
  - Reduce noisy notifications (e.g., "No information available")
  - Implement notification grouping for batch operations

- [ ] **28. Workspace/project indicators**
  - Show current workspace in statusline
  - Add commands to quickly switch between workspaces
  - Implement workspace-specific settings (per-project configurations)
  - Create workspace templates for common project types

---

## Advanced Features

- [ ] **29. AI-assisted coding enhancements**
  - Configure CodeCompanion with custom prompts for common tasks
  - Add keybindings for AI-assisted code review and documentation
  - Implement context-aware AI suggestions based on project type
  - Create templates for AI-assisted test generation

- [ ] **30. Multi-cursor and bulk editing**
  - Add visual multi-cursor support (vim-visual-multi or equivalent)
  - Implement macros for common bulk edit patterns
  - Add keymaps for column editing and manipulation
  - Create utilities for CSV/table editing

---

## Implementation Priority Guide

### High Priority (Immediate Impact)
Items 1-6, 13, 17, 24: These directly improve performance and daily usability

### Medium Priority (Quality of Life)
Items 7-12, 14-16, 25-27: Enhance workflow efficiency and comfort

### Low Priority (Polish & Long-term)
Items 18-23, 28-30: Important for maintainability and advanced features

---

## Success Metrics

Track these metrics to measure improvement impact:
- Startup time (target: <100ms)
- Time to first LSP response (target: <500ms)
- Average buffer count during development session
- Plugin count vs actively used plugins ratio
- Configuration maintainability score (subjective, based on ease of changes)

---

## Notes

- Check off items as completed
- Update this document with implementation notes and lessons learned
- Some improvements may conflict with each other - evaluate tradeoffs
- Benchmark before and after major changes to validate improvements
- Consider user feedback and actual usage patterns when prioritizing

**Last Updated:** 2025-10-29
