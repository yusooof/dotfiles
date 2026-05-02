import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../services" as S

PanelWindow {
    id: root
    visible: S.Visibilities.clipboard
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    anchors { top: true; bottom: true; left: true; right: true }

    MouseArea { anchors.fill: parent; onClicked: S.Visibilities.clipboard = false }
    Keys.onEscapePressed: S.Visibilities.clipboard = false

    onVisibleChanged: if (visible) { search.text = ""; search.forceActiveFocus() }

    Rectangle {
        anchors.centerIn: parent
        width: 540; height: 480
        radius: S.Theme.radius
        color: S.Theme.panelBg2
        border.color: S.Theme.border; border.width: 1
        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: S.Theme.padding
            spacing: S.Theme.gap

            TextField {
                id: search
                Layout.fillWidth: true
                placeholderText: "Filter clipboard…"
                color: S.Theme.fg
                placeholderTextColor: S.Theme.fgFaint
                font.family: S.Theme.fontFamily
                font.pixelSize: S.Theme.fontSize
                background: Rectangle {
                    color: S.Theme.surface; radius: S.Theme.radiusSm
                    border.color: search.activeFocus ? S.Theme.accent : "transparent"
                    border.width: 1
                }
                Keys.onEscapePressed: S.Visibilities.clipboard = false
                Keys.onReturnPressed: list.currentIndex >= 0 && list.paste(list.currentIndex)
                Keys.onDownPressed: list.incrementCurrentIndex()
                Keys.onUpPressed: list.decrementCurrentIndex()
            }

            ListView {
                id: list
                Layout.fillWidth: true; Layout.fillHeight: true
                clip: true
                currentIndex: 0
                model: {
                    const q = search.text.toLowerCase()
                    return q
                        ? S.Cliphist.entries.filter(e => e.preview.toLowerCase().includes(q))
                        : S.Cliphist.entries
                }
                function paste(i) {
                    const e = list.model[i]
                    if (!e) return
                    S.Cliphist.paste(e.id)
                    S.Visibilities.clipboard = false
                }

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: list.width
                    height: 36
                    radius: S.Theme.radiusSm
                    color: ListView.isCurrentItem ? S.Theme.hover : "transparent"

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        text: parent.modelData.preview
                        color: S.Theme.fg
                        elide: Text.ElideRight
                        font.family: S.Theme.fontMono
                        font.pixelSize: S.Theme.fontSizeSm
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { list.currentIndex = parent.index; list.paste(parent.index) }
                    }
                }
            }
        }
    }
}
