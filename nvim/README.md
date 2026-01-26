# Neovim Configuration

Modern Neovim configuration with LSP, completion, fuzzy finding, and more.

## Requirements

- Neovim >= 0.11.0
- Git
- Nerd Font (recommended)

## Installation

```bash
git clone https://github.com/tsegaye27/dotfiles ~/dotfiles
ln -s ~/dotfiles/nvim ~/.config/nvim
nvim
```

Or copy the nvim folder:

```bash
git clone https://github.com/tsegaye27/dotfiles ~/dotfiles
mkdir -p ~/.config
cp -r ~/dotfiles/nvim ~/.config/nvim
nvim
```

First launch will install plugins automatically.

## Key Bindings

- `<leader>` = Space
- `<leader>e` - Toggle file explorer
- `<leader>sf` - Search files
- `<leader>sg` - Live grep
- `<leader>f` - Format buffer
- `gd` - Go to definition
- `K` - Hover documentation
- `[d` / `]d` - Navigate diagnostics

See `lua/keymaps.lua` for all keybindings.

## Structure

```
nvim/
├── init.lua         # Plugin configuration
├── lua/
│   ├── settings.lua  # Neovim options
│   └── keymaps.lua  # Key mappings
```

## Customization

Edit `init.lua` to modify plugins, or `lua/settings.lua` for Neovim options.
