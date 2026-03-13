# NvChad Migration Guide

## What Was Done

### 1. Upgrade Neovim to 0.11+
```bash
brew untap homebrew/homebrew-cask-fonts  # fix stale tap if needed
brew upgrade neovim
nvim --version  # verify 0.11+
```

### 2. Clone Latest NvChad Starter
```bash
cd ~/Documents/Git/MyConfigs
git clone --depth 1 https://github.com/NvChad/starter.git nvim
rm -rf nvim/.git
```

### 3. Migrate Customizations

**`lua/chadrc.lua`** — set theme:
```lua
M.base46 = { theme = "darcula-dark" }
```

**`lua/options.lua`** — add custom options:
```lua
vim.opt.relativenumber = true
```

**`lua/configs/lspconfig.lua`** — add LSP servers:
```lua
require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "pyright", "ts_ls" }
vim.lsp.enable(servers)

-- terraformls with format-on-save
local lspconfig = require "lspconfig"
lspconfig.terraformls.setup {}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function() vim.lsp.buf.format() end,
})
```

**`lua/configs/conform.lua`** — add formatters:
```lua
formatters_by_ft = {
  lua = { "stylua" },
  css = { "prettier" },
  html = { "prettier" },
  javascript = { "prettierd", "prettier", stop_after_first = true },
  typescript = { "prettierd", "prettier", stop_after_first = true },
}
```

**`lua/plugins/init.lua`** — add plugins:
```lua
"mfussenegger/nvim-dap",
"mfussenegger/nvim-jdtls",
{ "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } },
```

**`ftplugin/java.lua`** — Java/JDTLS config with auto-detected paths:
- `jdtls` path via `brew --prefix jdtls` (no hardcoded versions)
- `java` binary via `brew --prefix openjdk@21`
- `config_mac` vs `config_linux` auto-detected
- Java runtimes (11, 17, 21) discovered from homebrew/corretto paths
- Filters out invalid bundles (`jacocoagent.jar`, `runner-jar-with-dependencies.jar`)

### 4. Symlink Config
```bash
rm -rf ~/.config/nvim
ln -s ~/Documents/Git/MyConfigs/nvim ~/.config/nvim
```

### 5. Clear Old Plugin Cache
```bash
rm -rf ~/.local/share/nvim/lazy ~/.local/state/nvim/lazy ~/.local/share/nvim/base46
```

### 6. Open Neovim
Launch `nvim` — lazy.nvim will bootstrap and install all plugins automatically.

## Repo Structure
```
~/Documents/Git/MyConfigs/
├── nvim/                  # NvChad config (symlinked to ~/.config/nvim)
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
├── .ideavimrc
├── .tmux.conf
└── vscode-settings.json
```
