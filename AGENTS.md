# AGENTS.md

## Audience
- This document is for autonomous coding agents working in this repository.
- Treat this repo as a personal Neovim config derived from `kickstart.nvim`.
- Prefer minimal, targeted edits that preserve current behavior unless a change request says otherwise.

## Project Overview
- Main entrypoint: `init.lua`
- Plugin modules: `lua/kickstart/plugins/*.lua`
- Health check module: `lua/kickstart/health.lua`
- Optional custom plugin area: `lua/custom/plugins/init.lua` (currently not imported in `init.lua`)
- Plugin lockfile: `lazy-lock.json`
- Formatting config: `.stylua.toml`
- CI workflow: `.github/workflows/stylua.yml`

## Rules Files (Cursor/Copilot)
- Checked for Cursor rules:
  - `.cursor/rules/` -> not present
  - `.cursorrules` -> not present
- Checked for Copilot rules:
  - `.github/copilot-instructions.md` -> not present
- If any of these files are added later, treat them as higher-priority constraints than this file.

## Build, Lint, and Test Commands

### Reality of this repo
- There is no traditional build step.
- There is no formal Lua test suite in this repository.
- CI currently checks Lua formatting only.

### Formatting and linting (shell)
- Run full formatting check (CI equivalent):
  - `stylua --check .`
- Auto-format all Lua files:
  - `stylua .`
- Check one file:
  - `stylua --check init.lua`
- Format one file:
  - `stylua lua/kickstart/plugins/debug.lua`
- Current style is defined in `.stylua.toml`.

### Runtime validation (inside Neovim)
- Open Neovim:
  - `nvim`
- Plugin manager status:
  - `:Lazy`
- Update plugins:
  - `:Lazy update`
- Tool/LSP manager:
  - `:Mason`
- Health checks:
  - `:checkhealth`
  - `:checkhealth kickstart`
- Formatter diagnostics:
  - `:ConformInfo`

### "Run a single test" guidance
- No single-test command exists because there is no test harness.
- Use this single-change verification flow instead:
  1. `stylua --check <changed-file>.lua`
  2. Open Neovim and run `:checkhealth kickstart`
  3. Exercise the changed behavior manually in one relevant buffer
- For keymap changes, validate with `:map <lhs>` or by invoking the mapping directly.
- For plugin-load changes, inspect plugin state in `:Lazy`.

### Suggested verification before finishing
- `stylua --check .`
- Start Neovim once and confirm no startup errors.
- Run `:checkhealth` and verify no newly introduced warnings.
- If LSP/formatter/linter settings changed, also validate via `:Mason` and `:ConformInfo`.

## Code Style and Architecture Guidelines

### Formatting
- Follow `.stylua.toml` exactly:
  - `indent_type = "Spaces"`
  - `indent_width = 2`
  - `line_endings = "Unix"`
  - `column_width = 160`
  - `quote_style = "AutoPreferSingle"`
  - `call_parentheses = "None"`
- Do not hand-format against Stylua output.

### Imports and module loading
- Prefer local requires when reused:
  - `local lint = require 'lint'`
  - `local builtin = require 'telescope.builtin'`
- Use one-off `require 'module'` calls only for single, obvious use sites.
- Keep requires close to where they are used unless shared in a function scope.

### Plugin spec patterns
- Plugin files should `return` a plugin spec table (or list of spec tables).
- Prefer declarative keys first: `event`, `ft`, `cmd`, `keys`, `opts`, `dependencies`.
- Use `opts = {}` when default setup is enough.
- Use `config = function()` only when custom setup logic is required.
- Keep each module focused on one plugin or one clear domain.

### Keymaps
- Use `vim.keymap.set`.
- Always provide a `desc` for discoverability.
- Use buffer-local mappings for LSP attach and plugin attach contexts.
- Preserve existing keymap families and mnemonics:
  - search: `<leader>s*`
  - LSP: `gr*`
  - git hunks/toggles: `<leader>h*`, `<leader>t*`

### Autocommands and augroups
- Create augroups with `vim.api.nvim_create_augroup`.
- Name groups clearly (`kickstart-*` or domain-specific names).
- Keep callbacks small and guarded to avoid noisy behavior.
- For lint/autocmd patterns, follow existing `modifiable` checks where relevant.

### Types, annotations, and API compatibility
- Use LuaLS annotations when they improve clarity (`---@type`, `---@param`, `---@return`).
- Keep compatibility helpers when supporting both stable/nightly Neovim APIs.
- Avoid excessive annotations for trivial locals.

### Naming conventions
- Prefer `snake_case` for locals/functions.
- Use clear names reflecting intent (`ensure_installed`, `lint_augroup`, `highlight_augroup`).
- Avoid one-letter names except in very small, idiomatic loops.

### Error handling
- For startup-critical failures, fail fast with explicit `error(...)`.
- For optional integrations/extensions, prefer `pcall(...)` plus graceful fallback.
- Check command failures when using `vim.fn.system(...)` via `vim.v.shell_error`.
- Use `vim.notify(..., vim.log.levels.ERROR/WARN/INFO)` for user-visible failures.
- Do not silently swallow errors unless reducing unavoidable noise.

### Performance and lazy-loading
- Prefer lazy-loading triggers (`event`, `ft`, `cmd`, `keys`) for new plugins.
- Only use eager loading (`lazy = false`) when behavior requires it.
- Avoid unnecessary global side effects in top-level scope.
- Keep plugin startup impact low; do expensive work inside `config` callbacks.

### Comments and documentation
- Keep comments short and useful; avoid repeating obvious code.
- Preserve instructional comments in `init.lua` unless change request says to remove them.
- When behavior is non-obvious, add a one-line rationale comment.

## Change Workflow for Agents
- Read all related files before editing.
- Match nearby style and patterns instead of introducing new paradigms.
- Keep diffs focused; avoid opportunistic refactors.
- Do not remove user-facing commands or keymaps without clear replacement.
- If adding a plugin:
  1. choose lazy-loading trigger(s),
  2. provide `desc` on user keymaps,
  3. verify startup and runtime behavior manually,
  4. ensure formatting passes.

## Definition of Done
- Changed Lua files pass `stylua --check`.
- Neovim starts without new errors.
- Relevant behavior changed by the patch is manually verified.
- No unrelated files are modified.
- This guide is updated if workflow/tooling conventions change.
