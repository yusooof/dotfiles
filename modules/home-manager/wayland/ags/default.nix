{ inputs, pkgs, ... }:

let
  astalPkgs = inputs.astal.packages.${pkgs.system};
in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    configDir = ./config;
    # Auto-start as a user service tied to graphical-session.target.
    # Hyprland exports its environment with `systemd.variables = [ "--all" ]`,
    # so the unit launches automatically once Hyprland is up.
    systemd.enable = true;
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
