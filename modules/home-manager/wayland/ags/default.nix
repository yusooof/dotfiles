{ inputs, pkgs, ... }:

let
  astalPkgs = inputs.astal.packages.${pkgs.system};
in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  # Disabled while we migrate to Quickshell. The TSX config under ./config
  # is intentionally kept around — flip `enable = true;` to bring it back.
  programs.ags = {
    enable = false;
    configDir = ./config;
    extraPackages = with astalPkgs; [
      hyprland
      tray
      wireplumber
      mpris
      network
      notifd
      apps
      battery
      io
    ];
  };
}
