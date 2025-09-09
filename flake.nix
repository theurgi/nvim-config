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
      nvim-config = nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [./config];
      };
    in {
      packages = {
        default = nvim-config.neovim;

        conform-formatters = pkgs.buildEnv {
          name = "conform-formatters";
          paths = with pkgs; [
            alejandra
            nodePackages.prettier
            shfmt
          ];
        };
      };

      devShells.default = pkgs.mkShell {
        packages = [
          nvim-config.neovim
          self.packages.${system}.conform-formatters
          pkgs.eslint
        ];
      };
    });
}
