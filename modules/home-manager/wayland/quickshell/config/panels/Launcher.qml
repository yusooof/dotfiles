import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../services" as S

PanelWindow {
    id: root
    visible: S.Visibilities.launcher
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    anchors {
        top: true; bottom: true; left: true; right: true
    }

    onVisibleChanged: if (visible) { search.text = ""; search.forceActiveFocus() }

    // Click-outside-to-close.
    MouseArea {
        anchors.fill: parent
        onClicked: S.Visibilities.launcher = false
    }

    Rectangle {
        id: card
        width: 560
        height: 480
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.18
        radius: S.Theme.radius
        color: S.Theme.panelBg2
        border.color: S.Theme.border
        border.width: 1

        // Eat clicks so the outer dismisser doesn't fire.
        MouseArea { anchors.fill: parent }

        Keys.onEscapePressed: S.Visibilities.launcher = false

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: S.Theme.padding
            spacing: S.Theme.gap

            TextField {
                id: search
                Layout.fillWidth: true
                placeholderText: "Type to search apps…"
                color: S.Theme.fg
                placeholderTextColor: S.Theme.fgFaint
                font.family: S.Theme.fontFamily
                font.pixelSize: S.Theme.fontSizeLg
                background: Rectangle {
                    color: S.Theme.surface
                    radius: S.Theme.radiusSm
                    border.color: search.activeFocus ? S.Theme.accent : "transparent"
                    border.width: 1
                }
                Keys.onDownPressed: list.incrementCurrentIndex()
                Keys.onUpPressed: list.decrementCurrentIndex()
                Keys.onReturnPressed: list.launch(list.currentIndex)
                Keys.onEscapePressed: S.Visibilities.launcher = false
            }

            ListView {
                id: list
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                currentIndex: 0

                function score(entry, query) {
                    if (!query) return 1
                    const q = query.toLowerCase()
                    const n = entry.name?.toLowerCase() ?? ""
                    const g = entry.genericName?.toLowerCase() ?? ""
                    const k = (entry.keywords ?? []).join(" ").toLowerCase()
                    if (n.startsWith(q)) return 100 - n.length
                    if (n.includes(q)) return 50 - n.length
                    if (g.includes(q)) return 30
                    if (k.includes(q)) return 20
                    return 0
                }

                model: {
                    const all = DesktopEntries.applications.values
                    const ranked = all
                        .map(e => ({ e, s: list.score(e, search.text) }))
                        .filter(x => x.s > 0)
                        .sort((a, b) => b.s - a.s)
                        .slice(0, 200)
                    return ranked.map(x => x.e)
                }

                function launch(i) {
                    const e = list.model[i]
                    if (!e) return
                    Quickshell.execDetached({
                        command: e.command,
                        workingDirectory: e.workingDirectory,
                    })
                    S.Visibilities.launcher = false
                }

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: list.width
                    height: 48
                    color: ListView.isCurrentItem ? S.Theme.hover : "transparent"
                    radius: S.Theme.radiusSm

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 12

                        IconImage {
                            implicitWidth: 32
                            implicitHeight: 32
                            source: parent.parent.modelData.icon
                                ? Quickshell.iconPath(parent.parent.modelData.icon, "application-x-executable")
                                : ""
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text {
                                text: parent.parent.parent.modelData.name ?? ""
                                color: S.Theme.fg
                                font.family: S.Theme.fontFamily
                                font.pixelSize: S.Theme.fontSize
                                font.weight: Font.DemiBold
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            Text {
                                text: parent.parent.parent.modelData.comment ?? parent.parent.parent.modelData.genericName ?? ""
                                visible: text !== ""
                                color: S.Theme.fgDim
                                font.family: S.Theme.fontFamily
                                font.pixelSize: S.Theme.fontSizeSm
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { list.currentIndex = parent.index; list.launch(parent.index) }
                    }
                }
            }
        }
    }
}
