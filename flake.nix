{
  description = "Official Nixos Home-Manager port";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nvf ={
    	url = "github:notashelf/nvf"; # Adding nvf as an input
     	inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nvf, ... }:
    let
      configuration = { pkgs, lib, ... }: {

      # system =  {
      # 	nixos = {
      #  		label = "Home-nvim-completion";
      #   	tags = [
      #     	        "Enablinng lsp diagnostics and autocomplete for neovim"
      #     ];
      #  };
      # };
        imports = [
          ./details/hardware-configuration.nix
        ];

        # The ignored
        nixpkgs.config.allowUnfree = true;
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        system.stateVersion = "25.11";
      }; in
    {
      nixosConfigurations."standard" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          configuration
        ];
      };
      homeConfigurations."oj2" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          nvf.homeManagerModules.default
          ./home.nix
        ];
      };
    };
}
