{ pkgs, ... }:

{
  programs.librewolf = {
    enable = true;

    profiles.default = {
      id = 0;
      isDefault = true;

      search = {
        default = "ddg";
        force = true;
        engines = {
          "Nix Packages" = {
            urls = [{ template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; }];
            icon = "https://nixos.org/favicon.png";
            definedAliases = [ "@np" ];
          };
          "NixOS Options" = {
            urls = [{ template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}"; }];
            icon = "https://nixos.org/favicon.png";
            definedAliases = [ "@no" ];
          };
          "Home Manager Options" = {
            urls = [{ template = "https://home-manager-options.extranix.com/?query={searchTerms}"; }];
            definedAliases = [ "@hm" ];
          };
        };
      };

      settings = {
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "browser.uidensity" = 1;
        "browser.toolbars.bookmarks.visibility" = "newtab";
        "privacy.resistFingerprinting" = false;
        "privacy.trackingprotection.enabled" = true;
        "network.cookie.lifetimePolicy" = 0;
        "gfx.webrender.all" = true;
        "layers.acceleration.force-enabled" = true;
        "webgl.force-enabled" = true;
        "webgl.disabled" = false;
        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.download.useDownloadDir" = true;
        "browser.startup.page" = 3;
      };

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        proton-pass
        refined-github
        stylus
        violentmonkey
      ];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };
}
