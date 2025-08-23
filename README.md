# nvim-config

A minimal, portable Neovim configuration built with [nvf](https://github.com/notashelf/nvf) and Nix flakes.

## Installation

### Quick Try

```bash
# Test without installing
nix run github:theurgi/nvim-config

# Install to profile
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

## Requirements

- Nix with flakes enabled
- Git (for installation from GitHub)
