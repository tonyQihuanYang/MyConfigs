# Ghostty Setup Guide

## Config Location
`~/.config/ghostty/config`

## Source
Config from: https://gist.githubusercontent.com/zhangchitc/7dead7c1b517390e061e07759ed80277/raw/

## Key Settings
- Theme: Catppuccin Mocha
- Font: Maple Mono NF CN (size 14) — install from https://github.com/subframe7536/maple-font
- Background opacity: 0.75 (semi-transparent with blur)
- Transparent macOS titlebar

## Keybindings Cheat Sheet

| Shortcut | Action |
|---|---|
| Cmd+T | New tab |
| Cmd+W | Close pane |
| Cmd+D | Split right |
| Cmd+Shift+D | Split down |
| Cmd+[ | Previous split |
| Cmd+] | Next split |
| Cmd+Alt+Arrow | Navigate splits directionally |
| Cmd+Shift+E | Equalize splits |
| Cmd+Shift+F | Zoom split |
| Cmd+Shift+, | Reload config |
| Ctrl+` | Toggle quick terminal (global) |
| Cmd+Plus/Minus | Adjust font size |
| Cmd+0 | Reset font size |

## Quick Setup on a New Machine
```bash
mkdir -p ~/.config/ghostty
curl -sL https://gist.githubusercontent.com/zhangchitc/7dead7c1b517390e061e07759ed80277/raw/ > ~/.config/ghostty/config
# Then adjust background-opacity if needed
```
