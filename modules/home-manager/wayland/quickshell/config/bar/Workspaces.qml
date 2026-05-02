import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "../services" as S

RowLayout {
    spacing: 3

    Repeater {
        model: 9
        delegate: Rectangle {
            required property int index
            readonly property int wsId: index + 1
            readonly property var ws: {
                for (const w of Hyprland.workspaces.values) {
                    if (w.id === wsId) return w
                }
                return null
            }
            readonly property bool active: Hyprland.focusedWorkspace?.id === wsId
            readonly property bool occupied: ws !== null

            implicitWidth: active ? 22 : 8
            implicitHeight: 8
            radius: 4
            color: active ? S.Theme.accent
                : occupied ? S.Theme.fgDim
                : S.Theme.fgFaint
            opacity: active ? 1 : occupied ? 0.85 : 0.4

            Behavior on implicitWidth { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 150 } }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("workspace " + parent.wsId)
            }
        }
    }
}
