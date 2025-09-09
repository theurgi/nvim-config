# nvim-config

A minimal, portable Neovim configuration built with [nvf](https://github.com/notashelf/nvf) and Nix flakes.

## Installation

### Quick Try

```bash
# Test without installing
nix run github:theurgi/nvim-config

# Install Neovim config (includes all LSP servers and tools)
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

## Development Tools

### All-in-One

```bash
# Install everything (LSP servers, formatters, linters)
nix profile install github:theurgi/nvim-config#dev-tools
```

### Selective Installation

```bash
# Install only LSP servers
nix profile install github:theurgi/nvim-config#lsp-servers

# Install only formatters
nix profile install github:theurgi/nvim-config#formatters

# Install only linters
nix profile install github:theurgi/nvim-config#linters
```

### Development Shell

```bash
# Enter a development shell with nvim + all tools
nix develop github:theurgi/nvim-config
```

## Requirements

- Nix with flakes enabled
