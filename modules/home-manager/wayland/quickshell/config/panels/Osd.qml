import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import "../services" as S

// Volume + brightness OSD. Auto-shows for 1.4s when the watched value changes
// (skipping the first sample so it doesn't flash on shell start).
Item {
    PwObjectTracker { objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : [] }

    QtObject {
        id: state
        property bool primed: false
        property string label: ""
        property real value: 0
        property string glyph: "󰕾"
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null
        ignoreUnknownSignals: true
        function onVolumeChanged() {
            if (!state.primed) { state.primed = true; return }
            const v = Pipewire.defaultAudioSink.audio.volume
            const m = Pipewire.defaultAudioSink.audio.muted
            state.label = "Volume"
            state.value = v
            state.glyph = m ? "󰝟" : v > 0.66 ? "󰕾" : v > 0.33 ? "󰖀" : "󰕿"
            timer.restart()
        }
        function onMutedChanged() { onVolumeChanged() }
    }

    Timer { id: timer; interval: 1400 }

    PanelWindow {
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Overlay
        anchors { bottom: true }
        implicitHeight: 80; implicitWidth: 280
        margins.bottom: 80
        visible: timer.running

        Rectangle {
            anchors.centerIn: parent
            width: 240; height: 60
            radius: S.Theme.radius
            color: S.Theme.panelBg2
            border.color: S.Theme.border; border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10
                Text {
                    text: state.glyph
                    color: S.Theme.fg
                    font.family: "Symbols Nerd Font"
                    font.pixelSize: 22
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 6
                    radius: 3
                    color: S.Theme.surface
                    Rectangle {
                        anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
                        width: parent.width * Math.max(0, Math.min(1, state.value))
                        radius: 3
                        color: S.Theme.accent
                    }
                }
                Text {
                    text: Math.round(state.value * 100) + "%"
                    color: S.Theme.fgDim
                    font.family: S.Theme.fontFamily
                    font.pixelSize: S.Theme.fontSizeSm
                    Layout.preferredWidth: 36
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
