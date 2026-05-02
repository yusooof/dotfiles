{ ... }:
let
  palette = import ./palette.nix;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];

    settings = {
      monitor = [ ",preferred,auto,1" ];

      "$mod" = "SUPER";
      "$term" = "foot";
      "$browser" = "chromium";
      "$fileManager" = "nautilus";

      env = [
        "XCURSOR_THEME,phinger-cursors-dark"
        "XCURSOR_SIZE,24"
        "GTK_THEME,Adwaita-dark"
        "QT_QPA_PLATFORMTHEME,gtk3"
      ];

      exec-once = [
        "hyprpaper"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "qs -c yusof"
      ];

      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = palette.hypr.activeBorder;
        "col.inactive_border" = palette.hypr.inactiveBorder;
        layout = "dwindle";
        resize_on_border = true;
        allow_tearing = false;
      };

      decoration = {
        rounding = 12;
        active_opacity = 1.0;
        inactive_opacity = 0.96;
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
        };
        shadow = {
          enabled = true;
          range = 16;
          render_power = 3;
          color = palette.hypr.shadow;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "smooth, 0.25, 0.46, 0.45, 0.94"
          "snappy, 0.2, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 4, snappy"
          "windowsOut, 1, 4, smooth, popin 80%"
          "border, 1, 8, default"
          "fade, 1, 6, smooth"
          "workspaces, 1, 5, smooth, slide"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = true;
      };

      # 0.49+ syntax: `gesture = <fingers>, <direction>, <action>`.
      gesture = [
        "3, horizontal, workspace"
        "4, horizontal, workspace"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        animate_manual_resizes = true;
        enable_swallow = true;
      };

      # `windowrulev2` was renamed to `windowrule` in 0.49+ (v1 was removed).
      windowrule = [
        "float, class:^(org.gnome.Calculator)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(pavucontrol)$"
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
      ];

      bind = [
        # Apps.
        "$mod, Return, exec, $term"
        "$mod, E, exec, $fileManager"
        "$mod SHIFT, B, exec, $browser"
        "$mod, L, exec, hyprlock"

        # Quickshell panels (must match GlobalShortcut names in
        # quickshell/config/shortcuts/Shortcuts.qml).
        "$mod, R,           global, quickshell:launcher"
        "$mod, slash,       global, quickshell:cheatsheet"
        "$mod, Escape,      global, quickshell:powerMenu"
        "$mod, Tab,         global, quickshell:overview"
        "$mod, A,           global, quickshell:sidebar"
        "$mod, V,           global, quickshell:clipboard"
        "$mod, period,      global, quickshell:emoji"
        "$mod, B,           global, quickshell:bluetooth"
        "$mod SHIFT, S,     global, quickshell:screenshot"
        "$mod SHIFT, C,     global, quickshell:colorPicker"

        # Window mgmt.
        "$mod, Q, killactive,"
        "$mod SHIFT, E, exit,"
        "$mod, F, fullscreen,"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, Space, togglefloating,"

        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute,        exec, wpctl set-mute   @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86MonBrightnessUp,  exec, brightnessctl s 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];

      bindl = [
        ",XF86AudioPlay,  exec, playerctl play-pause"
        ",XF86AudioNext,  exec, playerctl next"
        ",XF86AudioPrev,  exec, playerctl previous"
      ];
    };
  };
}
