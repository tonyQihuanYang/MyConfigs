# NvChad Migration Guide

## Prerequisites
```bash
# Upgrade Neovim to 0.11+
brew untap homebrew/homebrew-cask-fonts  # fix stale tap if needed
brew upgrade neovim
nvim --version  # verify 0.11+

# Install tools
brew install lazygit yazi ffmpegthumbnailer poppler fd ripgrep jq
```

## Fresh Setup on a New Machine

### 1. Clone the repo
```bash
git clone https://github.com/tonyQihuanYang/MyConfigs.git ~/Documents/Git/MyConfigs
```

### 2. Symlink all configs
```bash
# Neovim
rm -rf ~/.config/nvim
ln -s ~/Documents/Git/MyConfigs/nvim ~/.config/nvim

# Ghostty
mkdir -p ~/.config/ghostty
rm -f ~/.config/ghostty/config
ln -s ~/Documents/Git/MyConfigs/ghostty-config ~/.config/ghostty/config

# LazyGit
mkdir -p ~/Library/Application\ Support/lazygit
rm -f ~/Library/Application\ Support/lazygit/config.yml
ln -s ~/Documents/Git/MyConfigs/lazygit-config.yml ~/Library/Application\ Support/lazygit/config.yml
```

### 3. Clear old caches (if migrating)
```bash
rm -rf ~/.local/share/nvim/lazy ~/.local/state/nvim/lazy ~/.local/share/nvim/base46 ~/.local/share/eclipse
```

### 4. Open Neovim
Launch `nvim` — lazy.nvim will bootstrap and install all plugins automatically.

### 5. Add shell config to .zshrc
```bash
# Yazi file manager - cd to directory on quit
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Quick navigation
alias work="cd ~/Documents/Git2/couriers"
```

---

## What Was Customized

### `lua/chadrc.lua`
- Theme: `darcula-dark`
- Transparency enabled
- Background set to NONE for NvimTree and floats

### `lua/options.lua`
- `relativenumber = true`

### `lua/configs/lspconfig.lua`
- Uses `vim.lsp.enable()` (nvim 0.11+ API, no deprecated `require('lspconfig')` loop)
- Servers: `html`, `cssls`, `pyright`, `ts_ls`, `terraformls`
- Terraform format-on-save autocmd

### `lua/configs/conform.lua`
- Formatters: stylua (lua), prettier (css/html), prettierd/prettier (js/ts)

### `lua/plugins/init.lua`
- `nvim-dap` — debug adapter
- `nvim-jdtls` — Java LSP
- `diffview.nvim` — git diff viewer

### `lua/mappings.lua`
- `Space+gg` — open LazyGit in floating terminal

### `ftplugin/java.lua`
- Auto-detects jdtls path via `brew --prefix jdtls`
- Auto-detects Java binary via `brew --prefix openjdk@21`
- Auto-detects `config_mac` vs `config_linux`
- Auto-discovers Java runtimes (11, 17, 21) from homebrew/corretto
- Filters invalid bundles (`jacocoagent.jar`, `runner-jar-with-dependencies.jar`)

### `init.lua`
- Graceful base46 cache regeneration (pcall + auto-rebuild if missing)

---

## Repo Structure
```
~/Documents/Git/MyConfigs/
├── nvim/                    → ~/.config/nvim
│   ├── init.lua
│   ├── ftplugin/java.lua
│   └── lua/
│       ├── autocmds.lua
│       ├── chadrc.lua
│       ├── mappings.lua
│       ├── options.lua
│       ├── configs/
│       │   ├── conform.lua
│       │   ├── lazy.lua
│       │   ├── lspconfig.lua
│       │   └── util.lua
│       └── plugins/
│           └── init.lua
├── ghostty-config           → ~/.config/ghostty/config
├── lazygit-config.yml       → ~/Library/Application Support/lazygit/config.yml
├── nvchad-migration.md
├── terminal-setup.md
├── .ideavimrc
├── .tmux.conf
└── vscode-settings.json
```
