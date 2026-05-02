import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "../services" as S

// Toast-style transient popups in the top-right corner. Per-monitor.
// Center/feed view comes later (lives inside Sidebar).
Item {
    NotificationServer {
        id: server
        keepOnReload: false
        actionsSupported: true
        bodyMarkupSupported: true
        bodyImagesSupported: false
        bodySupported: true
        imageSupported: true
    }

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            required property var modelData
            screen: modelData
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Overlay
            anchors { top: true; right: true }
            implicitWidth: 360
            implicitHeight: Math.max(0, stack.implicitHeight + 16)
            visible: server.trackedNotifications.values.length > 0

            ColumnLayout {
                id: stack
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 12
                spacing: 8

                Repeater {
                    model: server.trackedNotifications
                    delegate: Rectangle {
                        required property var modelData
                        Layout.preferredWidth: 340
                        implicitHeight: content.implicitHeight + 20
                        radius: S.Theme.radius
                        color: S.Theme.panelBg2
                        border.color: S.Theme.border; border.width: 1

                        ColumnLayout {
                            id: content
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 4
                            Text {
                                Layout.fillWidth: true
                                text: parent.parent.modelData.summary
                                color: S.Theme.fg
                                font.family: S.Theme.fontFamily
                                font.pixelSize: S.Theme.fontSize
                                font.weight: Font.DemiBold
                                elide: Text.ElideRight
                            }
                            Text {
                                Layout.fillWidth: true
                                visible: parent.parent.modelData.body !== ""
                                text: parent.parent.modelData.body
                                color: S.Theme.fgDim
                                font.family: S.Theme.fontFamily
                                font.pixelSize: S.Theme.fontSizeSm
                                wrapMode: Text.WordWrap
                                maximumLineCount: 4
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: parent.modelData.dismiss()
                        }
                        Timer {
                            interval: 6000; running: true
                            onTriggered: parent.modelData.dismiss()
                        }
                    }
                }
            }
        }
    }
}
