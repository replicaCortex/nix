# Nix Configuration

Welcome to my Nix-based system configuration. This repository contains my
personal setup for a modern Linux desktop environment built with NixOS.

## Overview

This configuration includes a complete desktop environment centered around
Wayland, with custom configurations for:

- Window manager: [Niri](https://github.com/YaLTeR/niri) (Wayland compositor)
- Shell: [Fish](https://fishshell.com/)
- Editor: [Neovim](https://neovim.io/)
- Terminal: [Foot](https://codeberg.org/dnkl/foot)
- Browser: [Zen Browser](https://zen-browser.app/)
- Status bar: [Waybar](https://github.com/Alexays/Waybar)
- PDF reader: [Zathura](https://pwmt.org/projects/zathura/)
- Media player: [MPV](https://mpv.io/)

## Key Features

### Desktop Environment

- **Window Manager:** Niri - A tiling Wayland compositor optimized for
  productivity
- **Display Manager:** Ly - Lightweight display manager
- **Status Bar:** Waybar - Highly customizable Wayland bar
- **Notifications:** Dunst - Customizable notification daemon
- **Wallpaper:** swww - Smooth wallpaper switcher for Wayland

### Shell & Utilities

- **Shell:** Fish with custom aliases, environment variables, and functions
- **Prompt:** any-nix-shell integration for improved Nix shell experience
- **CLI Tools:**
  - `bat` - Cat clone with syntax highlighting
  - `broot` - Tree explorer with commands
  - `btop` - Resource monitor
  - `fzf` - Fuzzy finder
  - `ripgrep` - Fast search tool
  - `fd` - Friendly file finder
  - `just` - Command runner (like make but simpler)
  - `lsd` - Modern ls command
  - `jq` - JSON processor

### Development Tools

- **Editor:** Neovim with extensive plugin configuration
- **Language Servers:** Support for multiple languages via LSP
- **Formatters:** Alejandra, Stylua, Prettier, Shfmt for various file types
- **Code Search:** Ripgrep for fast text searching

### Media & Communication

- **Browser:** Zen Browser (Firefox-based with privacy enhancements)
- **PDF Reader:** Zathura - Minimalistic document viewer
- **Media Player:** MPV - Highly configurable media player
- **Image Viewer:** Vimiv - Vim-like image viewer
- **Torrent Client:** qBittorrent Enhanced
- **Messaging:** Telegram Desktop

### Fonts

- **Font Family:** Ubuntu (with Nerd Font patches)
- **Font Rendering:** Antialiasing disabled for crisp text

## Installation

To install this configuration:

```bash
# Link the configuration files (using the provided just command)
just install_config

# Switch to the new system configuration
sudo nixos-rebuild switch --flake .
```

Or use the provided just command:

```bash
just nrs
```

## Custom Commands

The configuration includes custom Just recipes for common tasks:

- `just nrs` - Switch system configuration with notifications
- `just ncg` - Clean up Nix store
- `just install_config` - Install dotfile symlinks
- `just fup` - Format files and push updates
- `just fmt` - Format all files with appropriate tools

## Special Features

- **Vim-like keybindings** in Fish shell (vi mode)
- **Custom wallpaper management** with swww
- **Clipboard history** with cliphist
- **Color temperature adjustment** with gammastep
- **XDG Portal support** for sandboxed applications
- **Nix direnv integration** for automatic environment activation

## Directory Structure

- `configuration/` - Main NixOS configuration files
- `dunst/` - Notification daemon settings
- `fish/` - Fish shell configuration
- `foot/` - Terminal emulator settings
- `niri/` - Window manager configuration
- `nvim/` - Neovim configuration
- `waybar/` - Status bar configuration
- `zathura/` - PDF viewer settings
- `mpv/` - Media player settings
- `vimiv/` - Image viewer settings

______________________________________________________________________

<p align="center">
Do you remember your promise?
</p>

<p align="center">
  Ну типа
  <br>
  <br>
  <img src="https://preview.redd.it/one-of-my-first-in-fact-my-second-fanart-of-ariane-ever-v0-lejo25pafc6e1.png?width=640&crop=smart&auto=webp&s=f546c10120b10445eb13a84478cb7666fdd6cf97" alt="ariane">
</p>
