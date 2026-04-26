{ config, lib, ... }:

let
  inherit (lib.hm.gvariant) mkTuple mkUint32;
in
{
  home.file.".background-image".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/assets/wallpaper.png";

  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Shift><Super>s" ];
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "blur-my-shell@aunetx"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "just-perfection-desktop@just-perfection"
        "copyous@boerdereinar.dev"
        "search-light@icedman.github.com"
        "rounded-window-corners@fxgn"
      ];
      favorite-apps = [
        "librewolf.desktop"
        "org.gnome.Nautilus.desktop"
        "com.raggesilver.BlackBox.desktop"
        "code.desktop"
        "equibop.desktop"
        "cider-2.desktop"
      ];
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.6;
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      brightness = 0.6;
      sigma = 26;
    };

    "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/hidetopbar" = {
      compatibility = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
      brightness = 0.6;
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur = true;
      customize = false;
      pipeline = "pipeline_default_rounded";
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
      brightness = 0.93;
      sigma = 19;
      override-background = true;
      static-blur = false;
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = true;
      brightness = 0.6;
      sigma = 30;
      override-background = true;
      static-blur = true;
      style-dash-to-dock = 0;
      pipeline = "pipeline_default_rounded";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      dock-fixed = false;
      autohide = true;
      intellihide = true;
      intellihide-mode = "ALL_WINDOWS";
      dash-max-icon-size = 40;
      transparency-mode = "DEFAULT";
      background-color = "rgb(54,54,58)";
      background-opacity = 0.35;
      custom-background-color = false;
      running-indicator-style = "DOTS";
      custom-theme-shrink = false;
      apply-custom-theme = false;
      show-trash = false;
      show-mounts = false;
      click-action = "minimize";
      scroll-action = "cycle-windows";
      animate-show-apps = true;
      always-center-icons = false;
      extend-height = false;
      height-fraction = 0.59;
      icon-size-fixed = true;
      isolate-monitors = false;
      isolate-workspaces = false;
      multi-monitor = false;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "DP-3";
      show-show-apps-button = false;
    };

    "org/gnome/shell/extensions/appindicator" = {
      icon-brightness = 0.0;
      icon-contrast = 0.0;
      icon-opacity = 100;
      icon-saturation = 0.0;
      icon-size = 0;
      tray-pos = "left";
    };

    "org/gnome/shell/extensions/just-perfection" = {
      animation = 5;
      startup-status = 0;
      support-notifier-showed-version = 36;
      theme = true;
      top-panel-position = 0;
      workspace-wrap-around = true;
    };

    "org/gnome/shell/extensions/copyous" = {
      auto-hide-search = false;
      clipboard-orientation = "horizontal";
      clipboard-position-horizontal = "fill";
      clipboard-position-vertical = "top";
      clipboard-size = 500;
      database-backend = "json";
      disable-hljs-dialog = false;
      dynamic-item-height = false;
      header-controls-visibility = "visible";
      history-length = 35;
      incognito = false;
      item-height = 170;
      item-width = 250;
      open-clipboard-dialog-shortcut = [ "<Super>v" ];
      show-at-pointer = false;
      show-header = true;
    };

    "org/gnome/shell/extensions/copyous/file-item" = {
      file-preview-visibility = "file-preview-or-file-info";
    };

    "org/gnome/shell/extensions/copyous/link-item" = {
      link-preview-orientation = "vertical";
    };

    "org/gnome/shell/extensions/copyous/theme" = {
      custom-bg-color = "";
      theme = "custom";
    };

    "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
      settings-version = mkUint32 7;
      skip-libadwaita-app = false;
    };

    "org/gnome/shell/extensions/search-light" = {
      animation-speed = 100.0;
      background-color = mkTuple [ 0.046666666865348816 0.037799999117851257 0.037799999117851257 0.68666666746139526 ];
      blur-background = true;
      blur-brightness = 0.6;
      blur-sigma = 30.0;
      border-radius = 3.1643835616438354;
      border-thickness = 0;
      entry-font-size = 1;
      monitor-count = 2;
      popup-at-cursor-monitor = true;
      preferred-monitor = 0;
      scale-height = 0.1;
      scale-width = 0.13;
      shortcut-search = [ "<Super>x" ];
      show-panel-icon = false;
      window-effect = 0;
    };

    "org/gnome/desktop/interface" = {
      accent-color = "slate";
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-weekday = true;
      clock-show-seconds = false;
      show-battery-percentage = true;
      cursor-theme = "phinger-cursors-dark";
      cursor-size = 24;
    };

    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri = "file:///home/user/.background-image";
      picture-uri-dark = "file:///home/user/.background-image";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
      center-new-windows = true;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-schedule-automatic = false;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      volume-step = 5;
    };

    "com/raggesilver/BlackBox" = {
      cursor-blink-mode = mkUint32 0;
      cursor-shape = mkUint32 1;
      easy-copy-paste = true;
      font = "JetBrains Mono Nerd Font 13";
      remember-window-size = true;
      scrollback-lines = mkUint32 10000;
      show-menu-button = false;
      terminal-cell-height = 1.0;
      terminal-cell-width = 1.0;
      terminal-padding = mkTuple [ (mkUint32 13) (mkUint32 13) (mkUint32 13) (mkUint32 13) ];
      theme-bold-is-bright = true;
      window-height = mkUint32 634;
      window-width = mkUint32 1115;
    };

    "org/gnome/gnome-system-monitor" = {
      show-dependencies = false;
      show-whose-processes = "user";
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "System" "Utilities" "YaST" "Pardus" ];
    };

    "org/gnome/desktop/app-folders/folders/System" = {
      name = "X-GNOME-Shell-System.directory";
      translate = true;
      apps = [
        "org.gnome.baobab.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.Logs.desktop"
        "org.gnome.SystemMonitor.desktop"
      ];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      name = "X-GNOME-Shell-Utilities.directory";
      translate = true;
      apps = [
        "org.gnome.Decibels.desktop"
        "org.gnome.Connections.desktop"
        "org.gnome.Papers.desktop"
        "org.gnome.font-viewer.desktop"
        "org.gnome.Loupe.desktop"
      ];
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      name = "suse-yast.directory";
      translate = true;
      categories = [ "X-SuSE-YaST" ];
    };

    "org/gnome/desktop/app-folders/folders/Pardus" = {
      name = "X-Pardus-Apps.directory";
      translate = true;
      categories = [ "X-Pardus-Apps" ];
    };
  };
}
