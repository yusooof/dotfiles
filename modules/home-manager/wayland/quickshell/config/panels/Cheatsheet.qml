import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../services" as S

PanelWindow {
    id: root
    visible: S.Visibilities.cheatsheet
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    anchors { top: true; bottom: true; left: true; right: true }

    MouseArea {
        anchors.fill: parent
        onClicked: S.Visibilities.cheatsheet = false
    }
    Keys.onEscapePressed: S.Visibilities.cheatsheet = false

    Rectangle {
        anchors.centerIn: parent
        width: Math.min(parent.width - 80, 880)
        height: Math.min(parent.height - 80, 640)
        radius: S.Theme.radius
        color: S.Theme.panelBg2
        border.color: S.Theme.border
        border.width: 1
        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: S.Theme.padding * 2
            spacing: S.Theme.gap

            Text {
                text: "Keybinds"
                color: S.Theme.fg
                font.family: S.Theme.fontFamily
                font.pixelSize: 22
                font.weight: Font.DemiBold
            }
            Text {
                text: "Press Esc or click outside to dismiss · Super = Mod"
                color: S.Theme.fgDim
                font.family: S.Theme.fontFamily
                font.pixelSize: S.Theme.fontSizeSm
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                GridLayout {
                    width: parent.width
                    columns: 2
                    columnSpacing: 24
                    rowSpacing: 18

                    Repeater {
                        model: S.Keybinds.groups
                        delegate: ColumnLayout {
                            required property var modelData
                            Layout.fillWidth: true
                            spacing: 4

                            Text {
                                text: parent.modelData.name
                                color: S.Theme.accent
                                font.family: S.Theme.fontFamily
                                font.pixelSize: S.Theme.fontSize
                                font.weight: Font.DemiBold
                            }
                            Repeater {
                                model: parent.parent.modelData.binds
                                delegate: RowLayout {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    spacing: 12
                                    Text {
                                        text: parent.modelData.keys
                                        color: S.Theme.fg
                                        font.family: S.Theme.fontMono
                                        font.pixelSize: S.Theme.fontSizeSm
                                        Layout.preferredWidth: 200
                                    }
                                    Text {
                                        text: parent.modelData.desc
                                        color: S.Theme.fgDim
                                        font.family: S.Theme.fontFamily
                                        font.pixelSize: S.Theme.fontSizeSm
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
