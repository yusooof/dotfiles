{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Nix
    nixd
    nixpkgs-fmt

    # CLI
    claude-code
    antigravity
  ];

  programs.mise = {
    enable = true;
    enableNushellIntegration = true;
  };
}
