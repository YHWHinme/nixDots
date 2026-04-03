{
  description = "Test flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      configuration = { pkgs, lib, config, ... }: {
        imports = [
          # Importing all the boring parts
          ./hardware-configuration.nix
        ];

        # Misc
        # nix.settings.experimental-features = ["nix-command" "flakes"];

        nixpkgs.config.allowUnfree = true; # Allowing unfreesoftware
        # Use the systemd-boot EFI boot loader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

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

        system.stateVersion = "25.11"; # Setting the nixos version
      }; in
    {
      # The block where the variables are used
      # Applying configuration up there
      nixosConfigurations.kate = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          configuration
        ];
      };

      packages.x86_64-linux = {
        # Applying configuration to these defaults
        default = self.nixosConfigurations.kate.config.system.build.toplevel;
      };
    };
}
