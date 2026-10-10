# Overview

Custom Neovim configuration built for the **nightly snapshot**.

## Features

- **Native Package Management**: Uses built-in `vim.pack.add()` (no plugin manager required)
- **Modern Editor Tools**: LSP, Treesitter and Completion `Blink.cmp`. "It just werks"
- **Nice UI Elements**: Smooth scrolling, which-key hints, status-line.
- **Navigation**: FZF-based file/buffer/grep searching with `fzf-lua`
- **Neovim Lua Configuration**: LSP and completions to configure neovim, with `plenary`.
- TODO: Coherent keybinds (copy doom emacs?).
- TODO: Package manager helpers?
    Something that deletes removed packages when delisted from vim.pack
    Keybinding for automatic update

lua vim.pack.del({ 'typescript-tools.nvim' })

