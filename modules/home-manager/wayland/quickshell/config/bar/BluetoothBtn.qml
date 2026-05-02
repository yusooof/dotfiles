import QtQuick
import Quickshell.Io
import "../services" as S

// Tiny indicator + click-to-open-picker. Real picker lives in panels/Bluetooth.qml.
Item {
    id: root
    property bool powered: false
    property int connected: 0

    implicitWidth: 22
    implicitHeight: 22

    Process {
        id: probe
        command: ["sh", "-c", "bluetoothctl show | grep Powered; bluetoothctl devices Connected | wc -l"]
        stdout: StdioCollector {
            onStreamFinished: {
                const txt = String(this.text)
                root.powered = txt.includes("Powered: yes")
                const m = txt.match(/(\d+)\s*$/)
                root.connected = m ? parseInt(m[1]) : 0
            }
        }
    }
    Timer { running: true; repeat: true; interval: 7000; triggeredOnStart: true; onTriggered: { probe.running = false; probe.running = true } }

    Text {
        anchors.centerIn: parent
        font.family: "Symbols Nerd Font"
        font.pixelSize: S.Theme.fontSize + 2
        color: root.connected > 0 ? S.Theme.accent : root.powered ? S.Theme.fg : S.Theme.fgFaint
        text: root.connected > 0 ? "󰂱" : root.powered ? "󰂯" : "󰂲"
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: S.Visibilities.toggle("bluetooth")
    }
}
