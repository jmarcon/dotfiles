# NEOVIM CONFIG AGENTS

## OVERVIEW
Neovim configuration built around lazy.nvim with modular plugin specs and a small core init.

## WHERE TO LOOK
- `Config/init.lua`: bootstrap entry; requires core config and plugin loader.
- `Config/lua/configuration.lua`: editor defaults (indent, keys, search, folds).
- `Config/lua/plugins/100_themes.lua`: color scheme definitions and defaults.
- `Config/lua/plugins/200_lualine.lua`: statusline setup and theme coupling.
- `Config/lua/plugins/300_dressing.lua`: UI prompt/selection enhancements.
- `Config/lua/plugins/350_styler.lua`: per-filetype/theme styling.
- `Config/lua/plugins/400_bufferline.lua`: buffer tabline behavior.
- `Config/lua/plugins/500_alpha.lua`: dashboard/greeter.
- `Config/lua/plugins/600_treesitter.lua`: parser installs and highlighting.
- `Config/lua/plugins/700_telescope.lua`: fuzzy finder and keymaps.
- `Config/lua/plugins/750_neotree.lua`: file explorer setup.
- `Config/lua/plugins/800_git.lua`: git signs and helpers.
- `Config/lua/plugins/825_todo.lua`: TODO comments UI.
- `Config/lua/plugins/850_ls.lua`: LSP servers and diagnostics.
- `Config/lua/plugins/900_cmp.lua`: completion engine and sources.
- `Config/lua/plugins/950_markdown.lua`: markdown tooling.
- `Config/lua/plugins/975_gh_copilot.lua`: GitHub Copilot integration.
- `.vimrc`: intentionally empty (legacy placeholder).

## CONVENTIONS
- Plugins are split into single-purpose files; keep each spec scoped and readable.
- Numbers in plugin filenames imply load grouping and rough ordering; preserve gaps.
- Prefer configuring plugin keymaps inside the plugin spec to keep behavior local.
- Use `configuration.lua` for core editor options, not plugin behavior.

## ANTI-PATTERNS
- Avoid adding settings directly in `init.lua` beyond minimal requires.
- Avoid mixing unrelated plugins in the same file.
- Do not resurrect `.vimrc`; keep it empty to prevent split sources of truth.
