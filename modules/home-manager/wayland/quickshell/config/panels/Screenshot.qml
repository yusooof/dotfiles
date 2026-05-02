import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../services" as S

PanelWindow {
    id: root
    visible: S.Visibilities.screenshot
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    anchors { top: true; bottom: true; left: true; right: true }

    MouseArea { anchors.fill: parent; onClicked: S.Visibilities.screenshot = false }
    Keys.onEscapePressed: S.Visibilities.screenshot = false

    readonly property var modes: [
        { glyph: "󰒅", label: "Region",     args: ["region"] },
        { glyph: "󱎓", label: "Window",     args: ["window"] },
        { glyph: "󰍹", label: "Output",     args: ["output"] },
        { glyph: "󰷆", label: "Region (edit)", args: ["region", "--edit", "swappy -f -"] },
    ]

    Rectangle {
        anchors.centerIn: parent
        width: 520; height: 180
        radius: S.Theme.radius
        color: S.Theme.panelBg2
        border.color: S.Theme.border; border.width: 1
        MouseArea { anchors.fill: parent }

        RowLayout {
            anchors.fill: parent
            anchors.margins: S.Theme.padding * 2
            spacing: S.Theme.gap

            Repeater {
                model: root.modes
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true; Layout.fillHeight: true
                    radius: S.Theme.radiusSm
                    color: hover.containsMouse ? S.Theme.hover : "transparent"
                    border.color: hover.containsMouse ? S.Theme.accent : S.Theme.border
                    border.width: 1
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 6
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: parent.parent.modelData.glyph
                            color: S.Theme.fg
                            font.family: "Symbols Nerd Font"
                            font.pixelSize: 32
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: parent.parent.modelData.label
                            color: S.Theme.fgDim
                            font.family: S.Theme.fontFamily
                            font.pixelSize: S.Theme.fontSizeSm
                        }
                    }
                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            S.Visibilities.screenshot = false
                            run.command = ["hyprshot", "-m", ...parent.modelData.args]
                            run.running = false; run.running = true
                        }
                    }
                }
            }
        }
    }
    Process { id: run }
}
