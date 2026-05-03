{ pkgs, ... }:
let
  palette = import ./palette.nix;
in
{
  home.packages = with pkgs; [
    grim
    slurp
    satty
    wl-clipboard
    cliphist
    brightnessctl
    playerctl
    libnotify
    libsecret        # D-Bus client lib for gnome-keyring
    seahorse         # GUI keyring manager
    networkmanagerapplet # nm-connection-editor for advanced WiFi from settings
    swww             # Wayland wallpaper daemon
  ];

  # Ensure screenshot output directory exists
  home.file."Pictures/Screenshots/.keep".text = "";


  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 660;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 2;
      };

      background = [
        {
          path = "$HOME/.background-image";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "300, 56";
          position = "0, -120";
          halign = "center";
          valign = "center";
          outline_thickness = 2;
          dots_size = 0.25;
          dots_spacing = 0.4;
          inner_color = palette.hyprlock.inputInner;
          outer_color = palette.hyprlock.inputOuter;
          font_color = palette.hyprlock.fg;
          fade_on_empty = false;
          placeholder_text = "<i>password…</i>";
          rounding = 16;
          shadow_passes = 2;
        }
      ];

      label = [
        {
          text = "cmd[update:1000] date +\"%H:%M\"";
          color = palette.hyprlock.fg;
          font_size = 96;
          font_family = "Inter Bold";
          position = "0, 240";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:60000] date +\"%A, %B %-d\"";
          color = palette.hyprlock.fgDim;
          font_size = 22;
          font_family = "Inter";
          position = "0, 160";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };


}
