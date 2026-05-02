import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../services" as S

// Minimal: lists known + connected devices via `bluetoothctl devices`, click to
// connect/disconnect. Pairing flow lives in `blueman-manager` for now (button).
PanelWindow {
    id: root
    visible: S.Visibilities.bluetooth
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    anchors { top: true; bottom: true; left: true; right: true }

    MouseArea { anchors.fill: parent; onClicked: S.Visibilities.bluetooth = false }
    Keys.onEscapePressed: S.Visibilities.bluetooth = false

    property var devices: []     // [{ mac, name, connected }]
    property bool powered: false

    function refresh() {
        list.running = false; list.running = true
    }
    onVisibleChanged: if (visible) refresh()

    Process {
        id: list
        command: ["sh", "-c",
            "bluetoothctl show | grep -E 'Powered:'; echo ---; " +
            "bluetoothctl devices Connected; echo ===; " +
            "bluetoothctl devices Paired"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = String(this.text).split(/^---$|^===$/m)
                root.powered = (parts[0] ?? "").includes("Powered: yes")
                const connectedSet = new Set()
                for (const ln of (parts[1] ?? "").split("\n")) {
                    const m = ln.match(/^Device (\S+) (.+)$/)
                    if (m) connectedSet.add(m[1])
                }
                const out = []
                for (const ln of (parts[2] ?? "").split("\n")) {
                    const m = ln.match(/^Device (\S+) (.+)$/)
                    if (m) out.push({ mac: m[1], name: m[2], connected: connectedSet.has(m[1]) })
                }
                out.sort((a, b) => (b.connected ? 1 : 0) - (a.connected ? 1 : 0))
                root.devices = out
            }
        }
    }
    Process { id: act; onExited: root.refresh() }

    Rectangle {
        anchors.centerIn: parent
        width: 460; height: 480
        radius: S.Theme.radius
        color: S.Theme.panelBg2
        border.color: S.Theme.border; border.width: 1
        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: S.Theme.padding
            spacing: S.Theme.gap

            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: "Bluetooth"
                    color: S.Theme.fg
                    font.family: S.Theme.fontFamily
                    font.pixelSize: S.Theme.fontSizeLg
                    font.weight: Font.DemiBold
                }
                Switch {
                    checked: root.powered
                    onToggled: { act.command = ["bluetoothctl", "power", checked ? "on" : "off"]; act.running = false; act.running = true }
                }
            }

            ListView {
                Layout.fillWidth: true; Layout.fillHeight: true
                clip: true
                model: root.devices
                delegate: Rectangle {
                    required property var modelData
                    width: ListView.view.width
                    height: 44
                    radius: S.Theme.radiusSm
                    color: hover.containsMouse ? S.Theme.hover : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10; anchors.rightMargin: 10
                        spacing: 10
                        Text {
                            Layout.fillWidth: true
                            text: parent.parent.modelData.name
                            color: S.Theme.fg
                            font.family: S.Theme.fontFamily
                            font.pixelSize: S.Theme.fontSize
                            elide: Text.ElideRight
                        }
                        Text {
                            visible: parent.parent.modelData.connected
                            text: "connected"
                            color: S.Theme.success
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
                            const verb = parent.modelData.connected ? "disconnect" : "connect"
                            act.command = ["bluetoothctl", verb, parent.modelData.mac]
                            act.running = false; act.running = true
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true; height: 36
                radius: S.Theme.radiusSm
                color: hover2.containsMouse ? S.Theme.hover : "transparent"
                border.color: S.Theme.border; border.width: 1
                Text {
                    anchors.centerIn: parent
                    text: "Open blueman-manager…"
                    color: S.Theme.fgDim
                    font.family: S.Theme.fontFamily
                    font.pixelSize: S.Theme.fontSizeSm
                }
                MouseArea {
                    id: hover2
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { act.command = ["blueman-manager"]; act.running = false; act.running = true }
                }
            }
        }
    }
}
