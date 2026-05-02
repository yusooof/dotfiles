import QtQuick
import Quickshell.Io
import "../services" as S

// Lightweight: poll `nmcli -t -f NAME,TYPE,DEVICE c show --active` once per
// 5s, show the active connection name + a wifi/ethernet glyph. Click → opens
// nm-connection-editor (richer pickers can come later).
Item {
    id: root
    property string name: ""
    property string kind: "" // "wifi" | "ethernet" | "vpn" | ""

    implicitWidth: row.implicitWidth + 8
    implicitHeight: 22

    Process {
        id: probe
        command: ["nmcli", "-t", "-f", "NAME,TYPE", "c", "show", "--active"]
        stdout: StdioCollector {
            onStreamFinished: {
                let n = "", k = ""
                for (const line of String(this.text).split("\n")) {
                    if (!line) continue
                    const [nm, ty] = line.split(":")
                    if (ty === "802-11-wireless") { n = nm; k = "wifi"; break }
                    if (ty === "802-3-ethernet") { n = nm; k = "ethernet"; break }
                    if (ty?.includes("vpn")) { n = nm; k = "vpn" }
                }
                root.name = n
                root.kind = k
            }
        }
    }

    Timer {
        running: true; repeat: true; interval: 5000
        triggeredOnStart: true
        onTriggered: { probe.running = false; probe.running = true }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4
        Text {
            color: root.name ? S.Theme.fg : S.Theme.fgFaint
            font.family: "Symbols Nerd Font"
            font.pixelSize: S.Theme.fontSize + 2
            text: root.kind === "ethernet" ? "󰈀"
                : root.kind === "vpn" ? "󰦝"
                : root.name ? "󰖩" : "󰖪"
        }
        Text {
            visible: root.name !== ""
            text: root.name
            elide: Text.ElideRight
            color: S.Theme.fgDim
            font.family: S.Theme.fontFamily
            font.pixelSize: S.Theme.fontSizeSm
            width: 90
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: editor.running = true
    }
    Process { id: editor; command: ["nm-connection-editor"] }
}
