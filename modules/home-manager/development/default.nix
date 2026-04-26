{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    nixd
    nixpkgs-fmt
    python3
    claude-code
    antigravity
  ];
}
