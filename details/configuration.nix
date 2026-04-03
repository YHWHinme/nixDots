{ config, lib, pkgs, ... }:

{
  imports =
    [ 
				# INclude NixOS-WSL modules
		    <nixos-wsl/modules>
    ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.oj2 = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh
    packages = with pkgs; [
      tree
    ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   # environment.systemPackages = with pkgs; [
   #   # Mainatance
   #   btop
   #   fastfetch
   #   # System essentials
   #   wezterm
   #   wget
   #   # For dependancy development
   #   gcc 
   #   cmake 
   #   # For development
   #   neovim
   #   uv
   #   go 
   #   bat 
   #   git
   #   rustup
   #   # Quality of life
   #   waypipe
   #   kanata
   #   carapace
   #   atuin
   #   zoxide
   #   yazi
   #   eza
   #   tmux 
   #   fzf
   #   zsh
   #   fd
   #   ripgrep
   #   # Connectivity
   #   croc
   # ];

	# System Settings
  fonts.packages = with pkgs; [ # Setting system fonts
        nerd-fonts.jetbrains-mono
  ];

  # Shell Setup: zsh
  programs.direnv.ennableZshIntegration = true; # New
  programs.zsh = {
  	enable = true;
		bashCompletion.enable = true;
  };

  # Misc services
  time.timeZone = "Europe/London"; # Setting your time zone.
  nixpkgs.config.allowUnfree = true; # Allowing unfree apps
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # networking.firewall.allowedTCPPorts = [
  # ];
  system.stateVersion = "25.11"; 
}

