import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../services" as S

// Wraps `hyprpicker` (eyedropper). Trigger fires-and-forgets — we don't host a
// popup; closing immediately is the better UX. The bind toggles Visibilities.colorPicker
// just so it's parallel with the other panels; we react to it in onVisibleChanged.
PanelWindow {
    id: root
    visible: false // never actually shown — we just react to the flag
    onVisibleChanged: visible = false

    Connections {
        target: S.Visibilities
        function onColorPickerChanged() {
            if (S.Visibilities.colorPicker) {
                pick.running = false
                pick.running = true
                S.Visibilities.colorPicker = false
            }
        }
    }

    Process {
        id: pick
        // hyprpicker -a copies hex to wl-clipboard. -n suppresses notifications.
        command: ["sh", "-c", "hyprpicker -a -f hex && notify-send 'Color copied' \"$(wl-paste)\""]
    }
}
