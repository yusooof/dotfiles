{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "toml"
      "html"
      "tailwind"
      "dockerfile"
      "docker-compose"
    ];

    extraPackages = with pkgs; [
      oxlint-latest
      oxfmt
      biome
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
          language_servers = [ "biome" "..." ];
          formatter = {
            external = {
              command = "oxfmt";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        TypeScript = {
          language_servers = [ "biome" "..." ];
          formatter = {
            external = {
              command = "oxfmt";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        "JavaScript React" = {
          language_servers = [ "biome" "..." ];
          formatter = {
            external = {
              command = "oxfmt";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        "TypeScript TSX" = {
          language_servers = [ "biome" "..." ];
          formatter = {
            external = {
              command = "oxfmt";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        JSON = {
          language_servers = [ "biome" "..." ];
          formatter = {
            external = {
              command = "oxfmt";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        HTML = {
          formatter = {
            external = {
              command = "oxfmt";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        CSS = {
          formatter = {
            external = {
              command = "oxfmt";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        Markdown = {
          soft_wrap = "editor_width";
          formatter = {
            external = {
              command = "oxfmt";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        YAML = {
          formatter = {
            external = {
              command = "oxfmt";
              arguments = [ "--stdin-filepath" "{buffer_path}" ];
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
        biome = {};
      };
    };
  };
}
