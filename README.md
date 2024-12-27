# MyConfigs

- `/nvim/*`   - old nvim config (deprecated)
- `/nvimLua/` - new nvim config
- `./ideavimrc` - vim confit for Intellij
- `./tmux.conf` - tmux config

---
# NVIM

## How to upload

- In this repo directory
- Copy your config files (Symlink works when your ~/.config link into this repo)
- Push it.

```bash
cp -r  ~/.config/nvim nvim
```

## Update Note
- 2024-12-26
 - Deprecated nvimLua
 - Use nvimChad
   - Delete the Symlink on `~/.config/nvim` by
   ```
   rm -rf ~/.config/nvim
   rm -rf ~/.local/state/nvim
   rm -rf ~/.local/share/nvim
   ```



## How to use it

- In your new machine, create the symlink from current directory to your config directory

```bash
pwd
ln -s <currentRepoPath>/nvimLua ~/.config/nvim
ln -s <currentRepoPath>/.ideavimrc ~/.ideavimrc
```

### Lsp setup (Java) - for nvimLua
```bash
brew install jdtls
sh ./install-java-debugger.sh
```

---
# Ideavim (For Intellij)

#### Plugins to install on Intellij
- IdeaVim
- Which-Key
- IdeaVim-Quickscope

```bash
pwd
ln -s <currentRepoPath>/.ideavimrc ~/.ideavimrc
ln -s <currentRepoPath>/.tmux.conf ~/. ~/.tmux.conf
```

---

# tmux

```bash
pwd
ln -s <currentrepopath>/.tmux.conf ~/.tmux.conf
```
