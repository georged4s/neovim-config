# Neovim Config

Lua dotfile. lazy.nvim plugin manager. No build/test — `nvim` launches and lazy installs plugins.

## Structure

```
init.lua              — entry: loads user/*, then config/lazy
lua/user/             — options, keymaps, autocommands, variables, filetypes
lua/config/plugins/   — per-plugin config (lsp/, telescope, treesitter, etc.)
after/plugin/         — runtime overrides (defaults.lua, telescope/extra.lua)
lazy-lock.json        — pinned plugin commits
```

Plugin spec imports: `config.plugins` then `config.plugins.lsp`.

## Key Facts

- **Leader**: Space (`<Space>` remapped to `<Nop>`, `vim.g.mapleader = " "`)
- **Indent**: 4 spaces, expandtab, tabstop=4
- **Undo**: persistent (`undofile`), stored in `~/.local/share/nvim/shada/undodir`. No swapfile, no backup.
- **Theme**: tokyonight night, transparent, terminal colors enabled
- **Autocomplete**: blink.cmp (Rust fuzzy matcher, builds on install via `:Lazy`)
- **LSP**: nvim-lspconfig + Mason + mason-lspconfig + mason-tool-installer
- **Python3 host**: `~/miniconda3/envs/neovim/bin/python` (hardcoded in variables.lua)
- **SQL env**: sqlfluff uses `~/miniconda3/envs/dbt/bin/sqlfluff` (hardcoded in none-ls.lua)
- **Treesitter**: parsers installed at setup time. Add parsers → edit `lua/config/plugins/treesitter.lua` → `:TSUpdate`
- **fzf-native**: needs `cmake` to build (handled by lazy `build` field)
- **markdown-preview**: needs `yarn` to build (`cd app && yarn install`)
- **Filetypes**: `.wxml` → xml, `.wxss` → css (WeChat mini-program)
- **Git**: gitsigns.nvim + vim-fugitive + vim-rhubarb
- **File explorer**: nvim-tree (toggle `<leader>e`)
- **Search**: telescope + fzf + live-grep-args (rg-based)
- **Code navigation**: telescope for references/definitions/implementations/symbols
- **LSP keymaps**: `<leader>l` prefix (format, info, mason, null-ls, inlay hints). Standard `gd`, `gr`, `grn`, `gra`, `gri`, `grt`, `grD`, `gO`, `gW`. Diagnostics: `<leader>lj/k`, `gl`
- **Git keymaps**: `<leader>g` prefix (blame, branches, commits, diff, status, log, hunk ops, browse). `(`/`)` for prev/next hunk. `gt`/`gy` for diffget
- **Harpoon**: `<leader>h1`–`h9`, `ha` (add), `hh` (menu), `hn`/`hp` (nav)
- **Quit**: `<leader>q` prefix (single/all windows). Uses `after/plugin/defaults.lua`
- **Session**: `<leader>W` saves `Session.vim` (gitignored)
- **Windows**: `<C-Up/Down/Left/Right>` resize. `<C-w>-`/`<C-w>|` swap split orientation
- **J/k**: wrap-aware (gj/gk) with count support
- **Markdown**: `<F6>` preview on, `<F7>` preview off
- **Diagnostics**: signs + underline (errors only), no virtual text. Float on `gl`
- **Formatting**: null-ls (none-ls) — black, prettierd, stylua, sqlfluff, shfmt, xmllint, yamllint
- **Auto**: foldlevelstart=99 (all folds open), autoread, cursorline, scrolloff=8
- **Telescope file_ignore_patterns**: .git/, secret, node_modules/, .*cache.*, Session.vim, target/

## Adding/Removing Plugins

1. Add to appropriate file under `lua/config/plugins/`
2. `:Lazy` to install/check

## Troubleshooting

- LSP not starting → `:Mason` to check installed tools, `:LspInfo` for status
- blink.cmp build failed → `:Lazy build blink.cmp`
- fzf-native missing → `:Lazy build telescope-fzf-native.nvim`
- Treesitter highlight broken → `:TSUpdate`
- Plugin conflict → check `after/plugin/` for overrides
