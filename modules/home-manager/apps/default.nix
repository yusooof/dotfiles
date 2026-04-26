{ pkgs, ... }:

{
  imports = [
    ./cider.nix
  ];

  home.packages = with pkgs; [
    equibop
    blackbox-terminal
  ];
}
