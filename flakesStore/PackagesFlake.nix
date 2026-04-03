{
  description = "Test flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      configuration = { pkgs, lib, config, ... }: {
        programs = {
          zsh.enable = true;
        };

        users.users.kate = {
          isNormalUser = true;
          shell = pkgs.bash;
        };

        environment.systemPackages = with pkgs; [
          btop
          neovim
          go
          atuin
          yazi
          tmux
        ];
      };
    in {
      # NixOS configuration (unchanged)
      nixosConfigurations.kate = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          configuration
        ];
      };

      # Packages
      packages.x86_64-linux =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in {
          default = pkgs.buildEnv {
            name = "all-packages";
            paths = [
              pkgs.btop
              pkgs.neovim
              pkgs.go
              pkgs.atuin
              pkgs.yazi
              pkgs.tmux
            ];
          };
        };
    };
}
