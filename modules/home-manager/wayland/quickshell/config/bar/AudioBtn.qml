import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io
import "../services" as S

Item {
    id: root
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    PwObjectTracker { objects: sink ? [sink] : [] }

    implicitWidth: 56
    implicitHeight: 22

    Row {
        anchors.centerIn: parent
        spacing: 4
        Text {
            text: root.muted ? "󰝟" : root.volume > 0.66 ? "󰕾" : root.volume > 0.33 ? "󰖀" : "󰕿"
            color: root.muted ? S.Theme.fgFaint : S.Theme.fg
            font.family: "Symbols Nerd Font"
            font.pixelSize: S.Theme.fontSize + 2
        }
        Text {
            text: Math.round(root.volume * 100) + "%"
            color: S.Theme.fgDim
            font.family: S.Theme.fontFamily
            font.pixelSize: S.Theme.fontSizeSm
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onWheel: function(w) {
            const delta = (w.angleDelta.y > 0 ? 0.05 : -0.05)
            mute.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (delta > 0 ? "5%+" : "5%-")]
            mute.running = false; mute.running = true
        }
        onClicked: function(e) {
            if (e.button === Qt.LeftButton) {
                mute.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
                mute.running = false; mute.running = true
            } else {
                pavu.running = false; pavu.running = true
            }
        }
    }

    Process { id: mute }
    Process { id: pavu; command: ["pavucontrol"] }
}
