{ pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    blur-my-shell
    user-themes
    dash-to-dock
    appindicator
    just-perfection
    copyous
    search-light
    rounded-window-corners-reborn
  ] ++ [ pkgs.phinger-cursors ];
}
