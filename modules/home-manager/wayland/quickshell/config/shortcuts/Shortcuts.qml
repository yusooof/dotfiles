import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../services" as S

// Each GlobalShortcut registers a Hyprland `global, quickshell:<name>` bind.
// The matching `bind = ...` lives in modules/home-manager/wayland/hyprland.nix.
Item {
    GlobalShortcut { appid: "quickshell"; name: "launcher";    onPressed: S.Visibilities.toggle("launcher") }
    GlobalShortcut { appid: "quickshell"; name: "cheatsheet";  onPressed: S.Visibilities.toggle("cheatsheet") }
    GlobalShortcut { appid: "quickshell"; name: "powerMenu";   onPressed: S.Visibilities.toggle("powerMenu") }
    GlobalShortcut { appid: "quickshell"; name: "clipboard";   onPressed: { S.Cliphist.refresh(); S.Visibilities.toggle("clipboard") } }
    GlobalShortcut { appid: "quickshell"; name: "emoji";       onPressed: S.Visibilities.toggle("emoji") }
    GlobalShortcut { appid: "quickshell"; name: "screenshot";  onPressed: S.Visibilities.toggle("screenshot") }
    GlobalShortcut { appid: "quickshell"; name: "colorPicker"; onPressed: S.Visibilities.toggle("colorPicker") }
    GlobalShortcut { appid: "quickshell"; name: "overview";    onPressed: S.Visibilities.toggle("overview") }
    GlobalShortcut { appid: "quickshell"; name: "sidebar";     onPressed: S.Visibilities.toggle("sidebar") }
    GlobalShortcut { appid: "quickshell"; name: "bluetooth";   onPressed: S.Visibilities.toggle("bluetooth") }
    GlobalShortcut { appid: "quickshell"; name: "closeAll";    onPressed: S.Visibilities.closeAll() }
}
