import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "../services" as S

Item {
    id: root
    readonly property var player: Mpris.players.values.find(p => p.playbackState === MprisPlaybackState.Playing) ?? Mpris.players.values[0] ?? null
    visible: player !== null
    implicitWidth: visible ? row.implicitWidth + 12 : 0
    implicitHeight: 22

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: "♪"
            color: S.Theme.accent
            font.pixelSize: S.Theme.fontSize
        }
        Text {
            Layout.maximumWidth: 220
            elide: Text.ElideRight
            text: root.player ? `${root.player.trackTitle} — ${root.player.trackArtist}` : ""
            color: S.Theme.fg
            font.family: S.Theme.fontFamily
            font.pixelSize: S.Theme.fontSize
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.player?.togglePlaying?.()
    }
}
