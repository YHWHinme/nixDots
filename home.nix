{ config, pkgs, ... }:

{
  home.username = "oj2";
  home.homeDirectory = "/home/oj2";
  home.stateVersion = "25.11";

  # Adding user packages
  home.packages = [
    pkgs.eza
    pkgs.git
    pkgs.go
    pkgs.yazi
    pkgs.croc
    pkgs.tldr
    pkgs.fd
    pkgs.bat
    pkgs.ripgrep
  ];

  programs = {
    nvf = { # Enabling nix vim framework
      enable = true;
      settings = { # nvf plugins and formatters
      # TODO: Add conform.nvim !
        vim = {
        # NOTE: Setting up the language servers
          languages = {
            nix = { # Enabling everything to do with nix
              lsp.enable = true;
            };
            python = { # Enabling the python lsp
              lsp.enable = true;
            };
          };
          # Adding formatters to the mix
          formatter.conform-nvim = {
            enable = true;
            setupOpts.formatters_by_ft = {
              python = [ # Adding the ruff formatter for python
                "ruff_format"
              ];
            };
          };
          # Adding inline diagnostics
          diagnostics.nvim-lint = {
            enable = true;
            linters_by_ft = {
              python = [
                "ruff"
              ];
            };
          };
        };
        vim.lazy.plugins = { # Setting up neovim plugins
          "aerial.nvim" = {
            package = pkgs.vimPlugins.aerial-nvim;
            setupModule = "aerial";
            setupOpts = {
              backends = [ "treesitter" "lsp" ];
            };
            keys = [
              { # Setting up floating window toggling for aerial
                key = "<leader>j";
                mode = "n";
                desc = "Aerial toggle";
                silent = true;
                action = "<cmd>AerialToggle!<CR>";
              }
            ];
          };
          "telescope.nvim" = {
            package = pkgs.vimPlugins.telescope-nvim;
            setupModule = "telescope";
            keys = [
              { # Telescope fuzzy finding files
                key = "<leader>ff";
                mode = "n";
                silent = true;
                desc = "Fuzzy Search files";
                action = "<cmd>Telescope find_files<CR>";
              }
            ];
          };
          "flash.nvim" = {
            package = pkgs.vimPlugins.flash-nvim;
            setupModule = "flash";
            keys = [
              { # Flash invoking jump
                key = "zz";
                mode = [ "n" "x" ];
                desc = "Invoking basic jump";
                lua = true;
                action = "require('flash').jump";
              }
            ];
          };
          "nvim-autopairs" = {
            package = pkgs.vimPlugins.nvim-autopairs;
            setupModule = "autopairs";
            setupOpts = {
              check_ts = true;
              ts_config = {
                lua = [ "string" ];
                javascript = [ "template_string" ];
                java = false;
              };
            };
          };
          "mini.ai" = { # For mini AI autodetect
            package = pkgs.vimPlugins.mini-ai;
            setupModule = "mini.ai";
          };
          "mini.surround" = { # For mini surround
            package = pkgs.vimPlugins.mini-surround;
            setupModule = "mini.surround";
          };
        };
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
    };
    git = {
      enable = true;
      settings = {
        alias = {
          st = "status";
          lg = "log --oneline --graph --decorate";
        };
        core.editor = "nvim";
        pull.rebase = true;
      };
    };

    zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
      };
      syntaxHighlighting.enable = true;
      initContent = ''
        # Setting the croc secret
        export CROC_SECRET="SomeSecret"
      '';
      shellAliases = {
        dir = "eza --color=always --git --long --no-filesize --icons=always --no-user --no-permissions --no-time -lTag --level=3 --git-ignore";
        tree = "eza --color=always --git --no-filesize --icons=always --no-user --tree --level=4";
        ls = "eza --color=always --icons=always";
        cd = "z";
      };
      enableCompletion = true;
    };

    starship = {
      enable = true;
    };

    television = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  home.sessionVariables = {
    # CROC_SECRET = "SomeSecret";
  };

  programs.home-manager.enable = true;
}
