pragma Singleton
import QtQuick
import Quickshell

// Mirror of modules/home-manager/wayland/palette.nix. Keep the two in sync.
// If you only edit one, edit palette.nix and copy values here — palette.nix
// is the source of truth (it also feeds hyprland borders / hyprlock).
Singleton {
    id: root

    readonly property color bg:        "#242424"
    readonly property color bgAlt:     "#1e1e1e"
    readonly property color surface:   "#303030"
    readonly property color surfaceHi: "#3a3a3a"
    readonly property color border:    "#454545"

    readonly property color fg:      "#ffffff"
    readonly property color fgDim:   "#bdbdbd"
    readonly property color fgFaint: "#7a7a7a"

    readonly property color accent:    "#6f8396"
    readonly property color accentHi:  "#8aa0b3"
    readonly property color accentDim: "#4f6373"

    readonly property color warn:    "#cd9178"
    readonly property color error:   "#c9695a"
    readonly property color success: "#7aa07a"

    // Translucent variants for layered surfaces.
    readonly property color panelBg:   Qt.rgba(0.141, 0.141, 0.141, 0.92) // bgAlt @ 92%
    readonly property color panelBg2:  Qt.rgba(0.188, 0.188, 0.188, 0.94)
    readonly property color hover:     Qt.rgba(1, 1, 1, 0.07)
    readonly property color pressed:   Qt.rgba(1, 1, 1, 0.12)
    readonly property color shadow:    Qt.rgba(0, 0, 0, 0.45)

    readonly property int radius:    14
    readonly property int radiusSm:  8
    readonly property int padding:   10
    readonly property int paddingSm: 6
    readonly property int gap:       8
    readonly property int barHeight: 36
    readonly property int barMargin: 8

    readonly property string fontFamily:  "Inter"
    readonly property string fontMono:    "JetBrains Mono"
    readonly property int    fontSize:    13
    readonly property int    fontSizeSm:  11
    readonly property int    fontSizeLg:  16
    readonly property int    fontWeight:  Font.Medium
}
