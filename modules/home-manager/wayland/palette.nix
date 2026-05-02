# Shared color palette for the Hyprland session: hyprland borders, hyprlock,
# and (eventually) quickshell. Mirrors GNOME Adwaita dark + the slate accent
# the user has set in dconf, so the Wayland session matches the GNOME one.
#
# To recolor everything at once, edit this file. Keep it dark; accents only.
rec {
  # Base surfaces (Adwaita dark).
  bg          = "#242424"; # window_bg
  bgAlt       = "#1e1e1e"; # view_bg, deeper
  surface     = "#303030"; # headerbar / sidebar
  surfaceHi   = "#3a3a3a"; # popover, hover
  border      = "#454545";

  # Foregrounds.
  fg          = "#ffffff";
  fgDim       = "#bdbdbd";
  fgFaint     = "#7a7a7a";

  # Slate accent (matches GNOME `accent-color = "slate"`).
  accent      = "#6f8396";
  accentHi    = "#8aa0b3";
  accentDim   = "#4f6373";

  # Status colors (muted, not loud).
  warn        = "#cd9178";
  error       = "#c9695a";
  success     = "#7aa07a";

  # Hyprland likes hex without `#` and with optional alpha.
  hypr = {
    activeBorder   = "rgba(6f8396ff) rgba(8aa0b3ff) 45deg";
    inactiveBorder = "rgba(45454599)";
    shadow         = "rgba(00000066)";
  };

  # Hyprlock / hypridle style strings (rgba with 0..1 alpha).
  hyprlock = {
    inputInner = "rgba(30, 30, 30, 0.85)";
    inputOuter = "rgba(111, 131, 150, 0.7)";
    fg         = "rgba(255, 255, 255, 1.0)";
    fgDim      = "rgba(189, 189, 189, 1.0)";
  };
}
