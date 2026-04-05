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
    pkgs.btop
    pkgs.tldr
    pkgs.fd
    pkgs.bat
    pkgs.ripgrep
  ];

  programs = {
  	atool = { # An archive manager, trying out new things
  		enable = true;
  	};
    nvf = { # Enabling nix vim framework

      enable = true;
      settings = { # nvf plugins and formatters
        vim = {

          # NOTE: Setting core vim opperations
          globals = { # Configs that will be defined everywhere
          	# Global keymaps
           	mapleader = " "; # Setting my leader keys
          };
          keymaps = [ # Unfinished setting global keymaps
                { # Removes highlights
                        keys = "<leader>nh";
                        action = "<cmd>noh<CR>";
                        mode = "n"
                };
          ];


          # NOTE: Essential additions
          autocomplete.blink-cmp = { # For intelisense
            enable = true;
            setupOpts = {
              cmdline.keymap.preset = "default";
              fuzzy.implementation = "prefer_rust";
            };
          };
          # Setting up the language servers
          languages = {
            lua = { # Enabling everything to do with nix
              lsp = { # Lua langauge support
                enable = true;
                servers = ["lua-language-server"];
              };
              treesitter.enable = true;
              extraDiganostics.enable = true;
              format = {
                enable = true; # Enables nix formatting
                type = "stylua"; # Uses the format tool type of such
              };
            };
            nix = { # Nix langauge support
              lsp = { # Lua langauge support
                enable = true;
                servers = ["nixd"];
              };
              treesitter.enable = true;
              extraDiganostics.enable = true;
              format = {
                enable = true; # Enables nix formatting
                type = "nixfmt"; # Uses the format tool type of such
              };
            };
            python = { # Enabling the python lsp
              lsp = {
                enable = true;
                servers = [ "ruff" ];
              };
              treesitter.enable = true;
              extraDiganostics.enable = true;
              format = {
                enable = true; # Enables nix formatting
                type = "ruff"; # Uses the format tool type of such
              };
            };
          };
          # Adding formatters to the mix
          formatter.conform-nvim = {
          # TODO: Put keys in here for formatting on demand
            enable = true;
            setupOpts.formatters_by_ft = {
              python = [ # Adding the ruff formatter for python
                "ruff_format"
              ];
            };
          };
          # Adding inline diagnostics
          diagnostics = { # BUG: Doesn't seem to be working right now
            enable = true;
            config = {
              virtual_text = true; # Setting virtual text on
            };
            nvim-lint = { #
              enable = true;
              linters_by_ft = {
                lua = [
                  "stylua"
                ];
                nix = [
                  "statix"
                ];
                python = [
                  "ruff"
                ];
              };
            };
          };
          lazy.plugins = { # Setting up neovim plugins
            "plenary.nvim" = { # Specifically for telescope or other plugins
              package = pkgs.vimPlugins.plenary-nvim;
            };
            "nvim-tree.lua" = { # Explorer pane
              package = pkgs.vimPlugins.nvim-tree-lua;
              setupModule = "nvim-tree";
              setupOpts = {
                git.enable = true;
                side = "right"; # New!!
                renderer.icons.show.git = true;
              };
              keys = [
                { # Toggle nvim-tree explorer
                  key = "<leader>ee";
                  mode = "n";
                  desc = "Toggle explorer";
                  silent = true;
                  action = "<cmd>NvimTreeToggle<CR>";
                }
              ];
            };
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
            # "flash.nvim" = {
            #   package = pkgs.vimPlugins.flash-nvim;
            #   setupModule = "flash";
            #   keys = [
            #     # { # Flash invoking jump
            #     #   key = "zz";
            #     #   mode = [ "n" "x" ];
            #     #   desc = "Invoking basic jump";
            #     #   lua = true;
            #     #   # action = "require(\'flash\').jump({})";
            #     # }
            #   ];
            # };
            "nvim-autopairs" = {
              package = pkgs.vimPlugins.nvim-autopairs;
              setupModule = "nvim-autopairs";
              setupOpts = {
                check_ts = true;
                ts_config = {
                  lua = [ "string" ];
                  javascript = [ "template_string" ];
                  java = false;
                };
              };
            };
            # NOTE: Non-essential addtions
            "gitsigns.nvim" = { # For mini surround
              package = pkgs.vimPlugins.gitsigns-nvim;
              setupModule = "gitsigns";
              setupOpts = {
                # TODO: Put the setupOpts in here
              }
            };

            terminal.toggleterm.lazygit = { # Enables lazygit for neovim
                enable = true;
                mappings.open = "<leader>lg" # Sets the keymap for lazygit
            }
          };
        # NOTE: Descretionary additions
        # luaConfigRC.aquarium = "vim.cmd('colorscheme aquiarum')" # Setting the colorscheme
                mini = { # Modern activation of mini services
                        statusline = {
                                enable = true; # For the bottom area of neovim
                        };
                        surround.enable = true; # For surround additions
                        ai.enable = true; # For AI surround areas
                        tabline.enable = true; # For the top level tabs for neovim
                        starter = true; # Neovim greeter
                        splitjoin = { # For arranging json easier
                                enable = true;
                                setupOpts = {
                                        mappings = {
                                                toggle = "gS";
                                                split = "";
                                                join = "";
                                        };
                                        detect = {
                                                separator =",";
                                        };
                                };
                        };
                };
        };
      };
    };

    atuin = { # For shell Ctrl-R usability
    		enable = true;
    		flags = [ "--disable-up-arrow" ];
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
      # enableZshIntegration = true;
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
