{ config, lib, ... }:

let
  inherit (lib.hm.gvariant) mkTuple mkUint32;
in
{
  home.file.".background-image".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/assets/wallpaper.png";

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "all-in-one-clipboard@NiffirgkcaJ.github.com"
        "blur-my-shell@aunetx"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "just-perfection-desktop@just-perfection"
        "Vitals@CoreCoding.com"
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

    "org/gnome/shell/extensions/all-in-one-clipboard" = {
      enable-recents-tab = true;
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.6;
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur = true;
      customize = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
      brightness = 0.6;
      sigma = 30;
      override-background = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = true;
      brightness = 0.6;
      sigma = 30;
      override-background = true;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "LEFT";
      dock-fixed = false;
      autohide = true;
      intellihide = true;
      dash-max-icon-size = 48;
      transparency-mode = "DEFAULT";
      background-opacity = 0.35;
      running-indicator-style = "DOTS";
      custom-theme-shrink = true;
      show-trash = false;
      show-mounts = false;
      click-action = "minimize";
      scroll-action = "cycle-windows";
      animate-show-apps = true;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      animation = 5;
      startup-status = 0;
      support-notifier-showed-version = 36;
      theme = true;
      top-panel-position = 1;
      workspace-wrap-around = true;
    };

    "org/gnome/shell/extensions/vitals" = {
      show-battery = true;
      hot-sensors = [
        "_memory_usage_"
        "_processor_usage_"
        "_temperature_"
      ];
      position-in-panel = 2;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-weekday = true;
      clock-show-seconds = false;
      show-battery-percentage = true;
    };

    "org/gnome/desktop/background" = {
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

    "com/raggesilver/BlackBox" = {
      font = "JetBrains Mono Nerd Font 13";
      easy-copy-paste = true;
      show-menu-button = false;
      scrollback-lines = lib.hm.gvariant.mkUint32 10000;
      remember-window-size = true;
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
