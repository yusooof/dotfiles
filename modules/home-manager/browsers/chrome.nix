{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;

    extensions = [
      { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # Proton Pass
      { id = "hlepfoohegkhhmjieoechaddaejaokhf"; } # Refined GitHub
      { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # Stylus
      { id = "jinjaccalgkegedbjjobinajignfemcm"; } # Violentmonkey
    ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "chromium-browser.desktop";
      "x-scheme-handler/http" = "chromium-browser.desktop";
      "x-scheme-handler/https" = "chromium-browser.desktop";
      "x-scheme-handler/about" = "chromium-browser.desktop";
      "x-scheme-handler/unknown" = "chromium-browser.desktop";
    };
  };
}
