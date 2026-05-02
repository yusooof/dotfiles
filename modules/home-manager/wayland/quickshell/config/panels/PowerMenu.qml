import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../services" as S

PanelWindow {
    id: root
    visible: S.Visibilities.powerMenu
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    anchors { top: true; bottom: true; left: true; right: true }

    MouseArea { anchors.fill: parent; onClicked: S.Visibilities.powerMenu = false }
    Keys.onEscapePressed: S.Visibilities.powerMenu = false

    readonly property var actions: [
        { glyph: "󰌾", label: "Lock",     cmd: ["loginctl", "lock-session"] },
        { glyph: "󰗽", label: "Logout",   cmd: ["hyprctl", "dispatch", "exit"] },
        { glyph: "󰒲", label: "Suspend",  cmd: ["systemctl", "suspend"] },
        { glyph: "󰜉", label: "Reboot",   cmd: ["systemctl", "reboot"] },
        { glyph: "󰐥", label: "Shutdown", cmd: ["systemctl", "poweroff"] },
    ]

    Rectangle {
        anchors.centerIn: parent
        width: 560; height: 200
        radius: S.Theme.radius
        color: S.Theme.panelBg2
        border.color: S.Theme.border; border.width: 1
        MouseArea { anchors.fill: parent }

        RowLayout {
            anchors.fill: parent
            anchors.margins: S.Theme.padding * 2
            spacing: S.Theme.gap

            Repeater {
                model: root.actions
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true; Layout.fillHeight: true
                    radius: S.Theme.radiusSm
                    color: hover.containsMouse ? S.Theme.hover : "transparent"
                    border.color: hover.containsMouse ? S.Theme.accent : S.Theme.border
                    border.width: 1

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: parent.parent.modelData.glyph
                            color: S.Theme.fg
                            font.family: "Symbols Nerd Font"
                            font.pixelSize: 36
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: parent.parent.modelData.label
                            color: S.Theme.fgDim
                            font.family: S.Theme.fontFamily
                            font.pixelSize: S.Theme.fontSize
                        }
                    }

                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            S.Visibilities.powerMenu = false
                            run.command = parent.modelData.cmd
                            run.running = false; run.running = true
                        }
                    }
                }
            }
        }
    }

    Process { id: run }
}
