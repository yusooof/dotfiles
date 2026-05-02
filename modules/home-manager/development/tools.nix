{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Nix
    nixd
    nixpkgs-fmt

    # Languages
    python3
    gcc
    nodejs
    qt6.qtdeclarative # provides qmlls / qmlformat

    # CLI
    claude-code
    antigravity
  ];

  programs.nix-index-database.comma.enable = true;

  programs.mise = {
    enable = true;
    enableNushellIntegration = true;
  };
}
