import QtQuick
import QtQuick.Layouts
import Quickshell
import "../services" as S

PanelWindow {
    id: bar
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: S.Theme.barHeight + S.Theme.barMargin * 2
    exclusiveZone: S.Theme.barHeight + S.Theme.barMargin

    Rectangle {
        id: pill
        anchors.fill: parent
        anchors.margins: S.Theme.barMargin
        anchors.leftMargin: S.Theme.barMargin + 4
        anchors.rightMargin: S.Theme.barMargin + 4
        radius: S.Theme.radius
        color: S.Theme.panelBg
        border.color: S.Theme.border
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: S.Theme.padding
            anchors.rightMargin: S.Theme.padding
            spacing: S.Theme.gap

            // ── left ────────────────────────────────────────────────
            RowLayout {
                spacing: S.Theme.gap
                Layout.alignment: Qt.AlignLeft
                Workspaces {}
                ActiveWindow {}
            }

            Item { Layout.fillWidth: true }

            // ── center ──────────────────────────────────────────────
            RowLayout {
                spacing: S.Theme.gap
                Layout.alignment: Qt.AlignHCenter
                Clock {}
                Mpris {}
            }

            Item { Layout.fillWidth: true }

            // ── right ───────────────────────────────────────────────
            RowLayout {
                spacing: S.Theme.gap
                Layout.alignment: Qt.AlignRight
                SysStats {}
                Tray {}
                NetworkBtn {}
                BluetoothBtn {}
                AudioBtn {}
            }
        }
    }
}
