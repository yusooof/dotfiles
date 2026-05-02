{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
