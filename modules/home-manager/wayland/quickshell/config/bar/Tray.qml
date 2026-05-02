import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "../services" as S

RowLayout {
    spacing: 4
    Repeater {
        model: SystemTray.items
        delegate: Item {
            required property var modelData
            implicitWidth: 18
            implicitHeight: 18
            IconImage {
                anchors.fill: parent
                source: parent.modelData.icon
                smooth: true
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: function(e) {
                    if (e.button === Qt.LeftButton) parent.modelData.activate()
                    else parent.modelData.secondaryActivate?.()
                }
            }
        }
    }
}
