# nvim-config

A minimal, portable Neovim configuration built with [nvf](https://github.com/notashelf/nvf) and Nix flakes.

## Installation

### Quick Try

```bash
# Test without installing
nix run github:theurgi/nvim-config

# Install Neovim config
nix profile install github:theurgi/nvim-config
```

### System Integration

Add to your NixOS configuration or home-manager:

```nix
# In your flake inputs
nvim-config.url = "github:theurgi/nvim-config";

# In your packages
environment.systemPackages = [
  inputs.nvim-config.packages.${system}.default
];
```

## Formatters

This configuration integrates [conform.nvim](https://github.com/stevearc/conform.nvim) for auto and manual code formatting.

To install the required formatting tools, use the bundled package:

```bash
# Install formatters into your profile
nix profile install github:theurgi/nvim-config#conform-formatters
```

This package includes:

- [`prettier`](https://prettier.io/) – JavaScript, TypeScript, Markdown
- [`alejandra`](https://github.com/kamadorueda/alejandra) – Nix files
- [`shfmt`](https://github.com/mvdan/sh) – POSIX/Bash/Zsh shell scripts

Conform.nvim will automatically pick up these formatters when available in `$PATH`.

## Requirements

- Nix with flakes enabled
