{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "biome"
      "nix"
      "toml"
      "html"
      "tailwind"
      "dockerfile"
      "docker-compose"
    ];

    extraPackages = with pkgs; [
      biome
      nodePackages.prettier
    ];

    userSettings = {
      # Theme — closest built-in equivalent to VSCode "Dark Modern"
      theme = "One Dark";

      # Font
      buffer_font_family = "JetBrains Mono";
      buffer_font_size = 14;
      buffer_font_features = { calt = true; };
      buffer_line_height = { custom = 1.6; };
      ui_font_size = 16;

      # Appearance
      minimap = { show = "never"; };
      show_whitespaces = "boundary";
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };

      # Behavior
      tab_size = 2;
      hard_tabs = false;
      format_on_save = "on";
      autosave = "on_focus_change";
      soft_wrap = "none";
      ensure_final_newline_on_save = true;
      remove_trailing_whitespace_on_save = true;
      show_inline_completions = true;

      # Inlay hints off unless manually toggled (mirrors "offUnlessPressed")
      inlay_hints = {
        enabled = false;
      };

      # Git inline blame — mirrors GitLens currentLine
      git = {
        inline_blame = {
          enabled = true;
          delay_ms = 600;
          show_commit_summary = true;
        };
      };

      # Terminal
      terminal = {
        font_size = 13;
        font_family = "JetBrains Mono";
        blinking = "on";
        line_height = { custom = 1.6; };
        font_features = { calt = true; };
      };

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      languages = {
        JavaScript = {
          formatter = {
            external = {
              command = "biome";
              arguments = [ "format" "--stdin-file-path" "{buffer_path}" ];
            };
          };
          code_actions_on_save = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
          };
        };
        TypeScript = {
          formatter = {
            external = {
              command = "biome";
              arguments = [ "format" "--stdin-file-path" "{buffer_path}" ];
            };
          };
          code_actions_on_save = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
          };
        };
        "JavaScript React" = {
          formatter = {
            external = {
              command = "biome";
              arguments = [ "format" "--stdin-file-path" "{buffer_path}" ];
            };
          };
          code_actions_on_save = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
          };
        };
        "TypeScript TSX" = {
          formatter = {
            external = {
              command = "biome";
              arguments = [ "format" "--stdin-file-path" "{buffer_path}" ];
            };
          };
          code_actions_on_save = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
          };
        };
        JSON = {
          formatter = {
            external = {
              command = "biome";
              arguments = [ "format" "--stdin-file-path" "{buffer_path}" ];
            };
          };
        };
        Nix = {
          formatter = "language_server";
          language_servers = [ "nixd" "!nil" ];
        };
        Rust = {
          formatter = "language_server";
        };
        HTML = {
          formatter = {
            external = {
              command = "prettier";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        CSS = {
          formatter = {
            external = {
              command = "prettier";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        Markdown = {
          soft_wrap = "editor_width";
          formatter = {
            external = {
              command = "prettier";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        YAML = {
          formatter = {
            external = {
              command = "prettier";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        TOML = {
          formatter = "language_server";
        };
      };

      lsp = {
        nixd = {
          initialization_options = {
            formatting.command = [ "nixpkgs-fmt" ];
          };
        };
      };
    };
  };
}
