_:

{
  programs = {
    nushell = {
      enable = true;
      extraConfig = ''
        $env.config = {
          show_banner: false,
        }
      '';
      extraEnv = ''
        $env.PATH = ($env.PATH | split row (char esep) | append /usr/local/bin | append ($env.HOME | path join .local/bin))
      '';
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        add_newline = false;
        format = "$directory$character";
        right_format = "$all";
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
        directory = {
          style = "bold cyan";
        };
      };
    };

    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };

    atuin = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
