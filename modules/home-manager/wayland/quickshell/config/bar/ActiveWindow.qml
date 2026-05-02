import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "../services" as S
Text {
    readonly property var client: Hyprland.activeToplevel
    text: client?.title ?? ""
    color: S.Theme.fgDim
    elide: Text.ElideRight
    maximumLineCount: 1
    font.family: S.Theme.fontFamily
    font.pixelSize: S.Theme.fontSize
    font.italic: true
    Layout.maximumWidth: 360
}
