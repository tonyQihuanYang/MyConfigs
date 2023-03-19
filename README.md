# MyConfigs

## How to upload

- In this repo directory
- Copy your config files (Symlink works when your ~/.config link into this repo)
- Push it.

```bash
cp -r  ~/.config/nvim nvim
```

## How to use it

- In your new machine, create the symlink from current directory to your config directory

```bash
pwd
ln -s <currentRepoPath>/nvim ~/.config/nvim
ln -s <currentRepoPath>/.ideavimrc ~/.ideavimrc
```

### Ideavim (For Intellij)

#### Plugins to install on Intellij

- IdeaVim
- Which-Key
- IdeaVim-Quickscope
