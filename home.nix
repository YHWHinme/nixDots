{ config, pkgs, ... }:

{
  home.username = "oj2";
  home.homeDirectory = "/home/oj2";
  home.stateVersion = "25.11";

  # Adding user packages
  home.packages = [
    # Formatter installation
    pkgs.nixfmt
    pkgs.ruff
    pkgs.basedpyright
    pkgs.lua-language-server
    pkgs.nixd

    # Development packages
    pkgs.go
    pkgs.mise
    pkgs.uv
    pkgs.deno

    # System use packages
    pkgs.eza
    pkgs.yazi
    pkgs.croc
    pkgs.git
    pkgs.btop
    pkgs.tldr
    pkgs.fd
    pkgs.bat
    pkgs.ripgrep

    pkgs.lazygit
  ];

  programs = {
    atool = {
      # An archive manager, trying out new things
      enable = true;
    };
    nvf = {
      # Enabling nix vim framework

      enable = true;
      settings = {
        # nvf plugins
        vim = {

          # NOTE: Setting core vim opperations
          globals = {
            # Configs that will be defined everywhere
            # Global keymaps
            mapleader = " "; # Setting my leader keys
          };
          options = {
            # Vim editor options
            tabstop = 2; # Number of spaces a Tab counts for
            shiftwidth = 2; # Number of spaces to use for autoindent
            expandtab = false; # Use spaces when Tab is pressed
          };
          keymaps = [
            # Setting global keymaps
            {
              # Removes highlights
              key = "<leader>ee";
              mode = "n";
              silent = true;
              action = "<cmd>NvimTreeToggle<CR>";
              desc = "Toggles Nvim tree";
            }
            {
              # Removes highlights
              key = "<leader>nh";
              mode = "n";
              silent = true;
              action = "<cmd>noh<CR>";
              desc = "Remove highlights";
            }
            {
              # Format buffer
              key = "<leader>mm";
              mode = "n";
              silent = true;
              lua = true;
              action = "function() require('conform').format({
							       	async = false,
							       	timeout_ms = 1000,
							       	lsp_fallback = true
							       }) end";
              desc = "Format buffer";
            }
          ];

          # NOTE: Essential additions
          diagnostics = {
            # Adding inline diagnostics
            enable = true;
            config = {
              virtual_text = true; # Setting virtual text on for diagnostics
            };
          };
          autocomplete.blink-cmp = {
            # For intelisense
            enable = true;
            setupOpts = {
              cmdline.keymap.preset = "default";
              fuzzy.implementation = "prefer_rust";
              sources.default = [
                "lsp"
                "path"
                "snippets"
                "buffer"
              ];
            };
          };

          # Setting up the language servers
          formatter.conform-nvim = {
            # In depth setup of formatter blcok
            enable = true; # Apparently I have to enable this for languages formatting to work
            setupOpts = {
              format_on_save = {
                lsp_format = "fallback";
                timeout_ms = 1000;
              };
              formatters_by_ft = {
                nix = [ "nixfmt" ];
                lua = [ "stylua" ];
                ts = [ "biomejs" ];
                python = [ "ruff" ];
              };
            };
          };
          languages = {
            go = {
              # Go code support
              lsp = {
                enable = true;
              };
              treesitter.enable = true;
              extraDiagnostics.enable = true;
            };
            lua = {
              # Enabling everything to do with nix
              lsp = {
                # Lua langauge support
                enable = true;
                servers = [ "lua-language-server" ];
              };
              treesitter.enable = true;
              extraDiagnostics.enable = true;
            };
            ts = {
              # Typescript langauge support
              enable = true;
              format = {
                enable = true;
                type = [ "prettier" ];
              };
              lsp = {
                # Lua langauge support
                enable = true;
                servers = [ "denols" ];
              };
              treesitter.enable = true;
              extraDiagnostics = {
                enable = true;
                types = [ "eslint_d" ];
              };
            };
            nix = {
              # Nix langauge support
              lsp = {
                # Lua langauge support
                enable = true;
                servers = [ "nixd" ];
              };
              treesitter.enable = true;
              extraDiagnostics.enable = true;
            };
            python = {
              # Nix langauge support
              lsp = {
                # Lua langauge support
                enable = true;
                servers = [
                  "basedpyright"
                  "ruff"
                ];
              };
              treesitter.enable = true;
              extraDiagnostics.enable = true;
            };
          };

          lazy.plugins = {
            # Dependency plugins
            "plenary.nvim" = {
              # Dependency for todo-comments and telescope
              package = pkgs.vimPlugins.plenary-nvim;
            };

            # Setting up neovim actual plugins
            "neoscroll.nvim" = {
              package = pkgs.vimPlugins.neoscroll-nvim; # For scrolling smoothly
            };
            "todo-comments.nvim" = {
              # For todo comments
              package = pkgs.vimPlugins.todo-comments-nvim;
              setupModule = "todo-comments"; # Was wrong before
              keys = [
                {
                  # Next todo comment
                  key = "]t";
                  mode = "n";
                  desc = "Next todo comment";
                  lua = true;
                  action = "function() require('todo-comments').jump_next() end";
                }
                {
                  # Previous todo comment
                  key = "[t";
                  mode = "n";
                  desc = "Previous todo comment";
                  lua = true;
                  action = "function() require('todo-comments').jump_prev() end";
                }
              ];
            };
            "telescope.nvim" = {
              package = pkgs.vimPlugins.telescope-nvim;
              # dependencies = [ "plenary" ];
              setupModule = "telescope";
              keys = [
                {
                  # Telescope fuzzy finding files
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
                {
                  # Flash invoking jump
                  key = "zz";
                  mode = [
                    "n"
                    "x"
                  ];
                  desc = "Invoking basic jump";
                  lua = true;
                  action = "function() require('flash').jump({}) end";
                }
              ];
            };
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
            "lazygit.nvim" = {
              # Adding lazygit package for working inside of neovim
              package = pkgs.vimPlugins.lazygit-nvim;
              lazy = true;
              # setupModule = "lazygit";
              keys = [
                {
                  action = "<cmd>LazyGit<CR>";
                  mode = "n";
                  silent = true;
                  key = "<leader>lg";
                  desc = "Open lazygit area";
                }
              ];
            };
            "gitsigns.nvim" = {
              # For gitsigns
              package = pkgs.vimPlugins.gitsigns-nvim;
              setupModule = "gitsigns";
              setupOpts = {
                signs = {
                  add = {
                    text = "┃";
                  };
                  change = {
                    text = "┃";
                  };
                  delete = {
                    text = "_";
                  };
                  topdelete = {
                    text = "‾";
                  };
                  changedelete = {
                    text = "~";
                  };
                  untracked = {
                    text = "┆";
                  };
                };
                signs_staged = {
                  add = {
                    text = "┃";
                  };
                  change = {
                    text = "┃";
                  };
                  delete = {
                    text = "_";
                  };
                  topdelete = {
                    text = "‾";
                  };
                  changedelete = {
                    text = "~";
                  };
                  untracked = {
                    text = "┆";
                  };
                };
                signs_staged_enable = true;
                signcolumn = true;
                numhl = false;
              };
            };
            "aerial.nvim" = {
              package = pkgs.vimPlugins.aerial-nvim;
              setupModule = "aerial";
              setupOpts = {
                backends = [
                  "treesitter"
                  "lsp"
                ];
              };
              keys = [
                {
                  # Setting up floating window toggling for aerial
                  key = "<leader>j";
                  mode = "n";
                  desc = "Aerial toggle";
                  silent = true;
                  action = "<cmd>AerialToggle!<CR>";
                }
              ];
            };

          };
          mini = {
            # Modern activation of mini services
            statusline = {
              enable = true; # For the bottom area of neovim
            };
            indentscope = {
              # For mini indentation
              enable = true;
              setupOpts = {
                delay = 50;
              };
            };
            surround.enable = true; # For surround additions
            ai.enable = true; # For AI surround areas
            tabline.enable = true; # For the top level tabs for neovim
            starter.enable = true; # Neovim greeter
            splitjoin = {
              # For arranging json easier
              enable = true;
              setupOpts = {
                mappings = {
                  toggle = "<leader>r";
                  split = "";
                  join = "";
                };
                detect = {
                  separator = ",";
                };
              };
            };
          };

          # NOTE: Descretionary additions

          theme = {
            # Setting up my neovim theme
            enable = true;
            transparent = true;
          };

          filetree.nvimTree = {
            # File tree configuration
            enable = true;
            setupOpts = {
              view.side = "right"; # Sends to the right side instead of left
            };
          };
        };
      };
    };

    atuin = {
      # For shell Ctrl-R usability
      enable = true;
      flags = [ "--disable-up-arrow" ]; # Disables the up arrow in atuin
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
        				export PATH="/home/oj2/.deno/bin:$PATH"
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
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  programs.home-manager.enable = true;
}
