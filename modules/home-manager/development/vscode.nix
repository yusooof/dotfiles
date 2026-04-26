{ pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Nix
      jnoortheen.nix-ide
      mkhl.direnv

      # Icons
      pkief.material-icon-theme

      # Git
      eamodio.gitlens
      mhutchie.git-graph
      (pkgs.vscode-utils.extensionFromVscodeMarketplace {
        name = "vscode-conventional-commits";
        publisher = "vivaxy";
        version = "1.27.0";
        sha256 = "sha256-yZ3pVBJGcwSNlN7LvFppAuNomxlQDTvA42kUpsZLj7Y=";
      })

      # Error display
      usernamehw.errorlens

      # Formatting & Linting
      biomejs.biome
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint

      # Language support
      bradlc.vscode-tailwindcss
      tamasfe.even-better-toml
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      ms-python.python
      ms-python.vscode-pylance

      # HTML/CSS
      formulahendry.auto-rename-tag
      naumovs.color-highlight

      # Productivity
      christian-kohler.path-intellisense
      aaron-bond.better-comments
      gruntfuggly.todo-tree
      oderwat.indent-rainbow

      # Tools
      humao.rest-client
      ms-azuretools.vscode-docker

      # Claude Code
      (pkgs.vscode-utils.extensionFromVscodeMarketplace {
        name = "claude-code";
        publisher = "anthropic";
        version = "2.1.114";
        sha256 = "sha256-TfVradC9ZjfLBp8QvZ0AptCS9j2ogzSlsRXxksp+N9I=";
      })
    ];

    profiles.default.userSettings = {
      # Immutable Settings Protection
      "files.readonlyInclude" = { "**/settings.json" = true; };

      # Nix LSP
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.serverSettings"."nixd"."formatting"."command" = [ "nixpkgs-fmt" ];

      # Theme
      "workbench.colorTheme" = "Dark Modern";
      "workbench.iconTheme" = "material-icon-theme";

      # Editor — appearance
      "editor.fontFamily" = "'JetBrains Mono', monospace";
      "editor.fontSize" = 14;
      "editor.fontLigatures" = true;
      "editor.lineHeight" = 1.6;
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "boundary";
      "editor.smoothScrolling" = true;
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = "active";
      "editor.stickyScroll.enabled" = true;
      "editor.inlayHints.enabled" = "offUnlessPressed";

      # Editor — behaviour
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.tabSize" = 2;
      "editor.insertSpaces" = true;
      "editor.wordWrap" = "off";
      "editor.inlineSuggest.enabled" = true;
      "editor.suggest.preview" = true;

      # Language-specific formatters
      "[javascript]" = { "editor.defaultFormatter" = "biomejs.biome"; };
      "[javascriptreact]" = { "editor.defaultFormatter" = "biomejs.biome"; };
      "[typescript]" = { "editor.defaultFormatter" = "biomejs.biome"; };
      "[typescriptreact]" = { "editor.defaultFormatter" = "biomejs.biome"; };
      "[json]" = { "editor.defaultFormatter" = "biomejs.biome"; };
      "[jsonc]" = { "editor.defaultFormatter" = "biomejs.biome"; };
      "[nix]" = { "editor.defaultFormatter" = "jnoortheen.nix-ide"; };

      # Workbench
      "workbench.startupEditor" = "none";
      "workbench.tree.indent" = 16;
      "workbench.smoothScrolling" = true;
      "workbench.list.smoothScrolling" = true;
      "workbench.editor.labelFormat" = "short";

      # Files
      "files.autoSave" = "onFocusChange";
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;

      # Terminal
      "terminal.integrated.fontSize" = 13;
      "terminal.integrated.smoothScrolling" = true;
      "terminal.integrated.cursorBlinking" = true;

      # Error Lens
      "errorLens.enabledDiagnosticLevels" = [ "error" "warning" "info" ];
      "errorLens.gutterIconsEnabled" = true;
      "errorLens.delay" = 200;

      # GitLens
      "gitlens.codeLens.enabled" = false;
      "gitlens.currentLine.enabled" = true;
      "gitlens.hovers.currentLine.over" = "line";

      # Git Graph
      "git-graph.date.format" = "Relative";

      # Indent Rainbow
      "indentRainbow.indicatorStyle" = "light";

      # Todo Tree
      "todo-tree.general.tags" = [ "TODO" "FIXME" "HACK" "NOTE" "BUG" ];
      "todo-tree.highlights.defaultHighlight" = {
        "icon" = "alert";
        "type" = "text";
      };

      # Explorer
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;

      # Telemetry
      "telemetry.telemetryLevel" = "off";
    };
  };
}
