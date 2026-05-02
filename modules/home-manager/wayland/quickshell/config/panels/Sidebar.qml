import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../services" as S

// Right-edge control center. v1: quick toggles + power button row. The richer
// content (notifications, mpris, system info) belongs in iteration 2.
PanelWindow {
    id: root
    visible: S.Visibilities.sidebar
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    anchors { top: true; bottom: true; right: true }
    implicitWidth: 360

    MouseArea {
        // Dismiss when clicking the panel margin only.
        anchors.fill: parent
        onClicked: function(e) {
            if (!card.contains(card.mapFromItem(parent, e.x, e.y))) S.Visibilities.sidebar = false
        }
    }
    Keys.onEscapePressed: S.Visibilities.sidebar = false

    Rectangle {
        id: card
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: S.Theme.padding
        width: 340
        radius: S.Theme.radius
        color: S.Theme.panelBg2
        border.color: S.Theme.border; border.width: 1
        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: S.Theme.padding * 1.5
            spacing: S.Theme.gap * 1.5

            Text {
                text: "Quick toggles"
                color: S.Theme.fgDim
                font.family: S.Theme.fontFamily
                font.pixelSize: S.Theme.fontSizeSm
                font.weight: Font.DemiBold
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 8; rowSpacing: 8

                Toggle { label: "Do not disturb"; glyph: "󰂛"; onTriggered: cmd.run(["makoctl", "mode", "-t", "do-not-disturb"]) }
                Toggle { label: "Mic mute";       glyph: "󰍭"; onTriggered: cmd.run(["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"]) }
                Toggle { label: "Idle inhibit";   glyph: "󰒲"; onTriggered: cmd.run(["systemctl", "--user", "is-active", "hypridle.service"]) /* TODO: real toggle */ }
                Toggle { label: "Night light";    glyph: "󰽢"; onTriggered: cmd.run(["sh", "-c", "pgrep wlsunset && pkill wlsunset || wlsunset -t 3500 -T 6500 &"]) }
            }

            Item { Layout.fillHeight: true }

            Text {
                text: "Session"
                color: S.Theme.fgDim
                font.family: S.Theme.fontFamily
                font.pixelSize: S.Theme.fontSizeSm
                font.weight: Font.DemiBold
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 6
                Toggle { label: "Lock";     glyph: "󰌾"; Layout.fillWidth: true; onTriggered: cmd.run(["loginctl", "lock-session"]) }
                Toggle { label: "Power";    glyph: "󰐥"; Layout.fillWidth: true; onTriggered: { S.Visibilities.sidebar = false; S.Visibilities.powerMenu = true } }
            }
        }
    }

    QtObject {
        id: cmd
        function run(c) { proc.command = c; proc.running = false; proc.running = true }
    }
    Process { id: proc }

    component Toggle: Rectangle {
        id: tog
        property string label
        property string glyph
        signal triggered()
        Layout.fillWidth: true
        implicitHeight: 64
        radius: S.Theme.radiusSm
        color: hover.containsMouse ? S.Theme.hover : S.Theme.surface
        border.color: hover.containsMouse ? S.Theme.accent : "transparent"
        border.width: 1

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 4
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: tog.glyph
                color: S.Theme.fg
                font.family: "Symbols Nerd Font"
                font.pixelSize: 20
            }
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: tog.label
                color: S.Theme.fgDim
                font.family: S.Theme.fontFamily
                font.pixelSize: S.Theme.fontSizeSm
            }
        }
        MouseArea {
            id: hover
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: tog.triggered()
        }
    }
}
