import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../services" as S

// Minimal workspace grid: 3x3, click to switch. TODO: live thumbnails via
// ScreencopyView once we wire it; this is the v1.
PanelWindow {
    id: root
    visible: S.Visibilities.overview
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    anchors { top: true; bottom: true; left: true; right: true }

    MouseArea { anchors.fill: parent; onClicked: S.Visibilities.overview = false }
    Keys.onEscapePressed: S.Visibilities.overview = false

    Rectangle {
        anchors.centerIn: parent
        width: 720; height: 540
        radius: S.Theme.radius
        color: S.Theme.panelBg2
        border.color: S.Theme.border; border.width: 1
        MouseArea { anchors.fill: parent }

        Grid {
            anchors.centerIn: parent
            columns: 3; rows: 3
            spacing: 12

            Repeater {
                model: 9
                delegate: Rectangle {
                    required property int index
                    readonly property int wsId: index + 1
                    readonly property bool active: Hyprland.focusedWorkspace?.id === wsId
                    readonly property var ws: {
                        for (const w of Hyprland.workspaces.values) if (w.id === wsId) return w
                        return null
                    }

                    width: 200; height: 140
                    radius: S.Theme.radiusSm
                    color: active ? S.Theme.accentDim : ws ? S.Theme.surface : S.Theme.bgAlt
                    border.color: active ? S.Theme.accent : S.Theme.border
                    border.width: active ? 2 : 1

                    Text {
                        anchors.centerIn: parent
                        text: parent.wsId + (parent.ws ? ` · ${parent.ws.lastIpcObject?.windows ?? ""} win` : "")
                        color: S.Theme.fg
                        font.family: S.Theme.fontFamily
                        font.pixelSize: S.Theme.fontSizeLg
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Hyprland.dispatch("workspace " + parent.wsId)
                            S.Visibilities.overview = false
                        }
                    }
                }
            }
        }
    }
}
