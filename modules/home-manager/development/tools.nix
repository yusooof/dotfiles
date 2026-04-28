{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Nix
    nixd
    nixpkgs-fmt

    # Languages
    python3
    gcc
    nodejs

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
