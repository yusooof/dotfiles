{ pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    all-in-one-clipboard
    blur-my-shell
    user-themes
    dash-to-dock
    appindicator
    just-perfection
    copyous
    search-light
  ] ++ [ pkgs.phinger-cursors ];
}
