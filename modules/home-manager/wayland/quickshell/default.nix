{ inputs, pkgs, ... }:
let
  qs = inputs.quickshell.packages.${pkgs.system}.default;
in
{
  home.packages = [
    qs
    pkgs.networkmanager # nmcli for the network module
    pkgs.bluez          # bluetoothctl
    pkgs.wl-clipboard   # wl-copy for clipboard / emoji / colorpicker
    pkgs.cliphist
    pkgs.grim
    pkgs.slurp
    pkgs.swappy
    pkgs.hyprpicker
  ];

  # Symlink the whole config tree to ~/.config/quickshell/yusof. `qs` will
  # auto-pick `shell.qml` as the entry point. To run another config in
  # parallel, copy this dir under a different name.
  xdg.configFile."quickshell/yusof" = {
    source = ./config;
    recursive = true;
  };

  # Quickshell autostarts inside Hyprland (see hyprland.nix exec-once).
}
