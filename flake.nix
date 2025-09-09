{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nvf,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      formatters = with pkgs; [
        alejandra
        prettier
        shfmt
      ];

      linters = with pkgs; [
        eslint
      ];

      lsp-servers = with pkgs; [
        bash-language-server
        lua-language-server
        marksman
        nil
        typescript-language-server
      ];

      nvim-config = nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [./config];
      };
    in {
      packages = {
        default = nvim-config.neovim;

        lsp-servers = pkgs.buildEnv {
          name = "nvim-lsp-servers";
          paths = lsp-servers;
        };

        formatters = pkgs.buildEnv {
          name = "nvim-formatters";
          paths = formatters;
        };

        linters = pkgs.buildEnv {
          name = "nvim-linters";
          paths = linters;
        };

        # Combined package for all tools
        dev-tools = pkgs.buildEnv {
          name = "nvim-dev-tools";
          paths = lsp-servers ++ formatters ++ linters;
        };
      };

      devShells.default = pkgs.mkShell {
        packages = [
          nvim-config.neovim
          self.packages.${system}.dev-tools
        ];
      };
    });
}
