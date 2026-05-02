import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../services" as S

PanelWindow {
    id: root
    visible: S.Visibilities.emoji
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    anchors { top: true; bottom: true; left: true; right: true }

    MouseArea { anchors.fill: parent; onClicked: S.Visibilities.emoji = false }
    Keys.onEscapePressed: S.Visibilities.emoji = false
    onVisibleChanged: if (visible) { search.text = ""; search.forceActiveFocus() }

    // Curated short list. To get a full one, replace this with a JSON file
    // loaded at startup (TODO: data/emojis.json + FileView).
    readonly property var emojis: [
        { e: "👍", k: "thumbs up like ok" },
        { e: "🙏", k: "pray thanks please" },
        { e: "🔥", k: "fire hot" },
        { e: "✨", k: "sparkles shiny" },
        { e: "🎉", k: "party tada celebrate" },
        { e: "💯", k: "hundred score" },
        { e: "❤️", k: "heart love" },
        { e: "😂", k: "laugh tears joy" },
        { e: "🤔", k: "thinking hmm" },
        { e: "😅", k: "sweat smile awkward" },
        { e: "😎", k: "cool sunglasses" },
        { e: "🥲", k: "happy tear" },
        { e: "🫡", k: "salute" },
        { e: "🙃", k: "upside down" },
        { e: "👀", k: "eyes look" },
        { e: "💀", k: "skull dead lol" },
        { e: "🚀", k: "rocket ship launch" },
        { e: "✅", k: "check ok done" },
        { e: "❌", k: "cross x no" },
        { e: "⚠️", k: "warning caution" },
        { e: "💻", k: "laptop computer" },
        { e: "🐛", k: "bug" },
        { e: "📦", k: "package box" },
        { e: "🛠️", k: "tools build" },
        { e: "🔧", k: "wrench fix" },
        { e: "📝", k: "memo note" },
        { e: "📅", k: "calendar date" },
        { e: "⏰", k: "alarm clock time" },
        { e: "💡", k: "idea bulb" },
        { e: "📌", k: "pin" },
        { e: "🎯", k: "target dart" },
        { e: "🧠", k: "brain" },
        { e: "👋", k: "wave hello hi" },
        { e: "🤝", k: "handshake deal" },
        { e: "🙌", k: "raised hands praise" },
        { e: "🤷", k: "shrug" },
        { e: "🤦", k: "facepalm" },
    ]

    Rectangle {
        anchors.centerIn: parent
        width: 540; height: 460
        radius: S.Theme.radius
        color: S.Theme.panelBg2
        border.color: S.Theme.border; border.width: 1
        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: S.Theme.padding
            spacing: S.Theme.gap

            TextField {
                id: search
                Layout.fillWidth: true
                placeholderText: "Search emoji…"
                color: S.Theme.fg
                placeholderTextColor: S.Theme.fgFaint
                font.family: S.Theme.fontFamily
                font.pixelSize: S.Theme.fontSize
                background: Rectangle {
                    color: S.Theme.surface; radius: S.Theme.radiusSm
                    border.color: search.activeFocus ? S.Theme.accent : "transparent"
                    border.width: 1
                }
                Keys.onEscapePressed: S.Visibilities.emoji = false
            }

            ScrollView {
                Layout.fillWidth: true; Layout.fillHeight: true
                clip: true

                Grid {
                    columns: 10
                    spacing: 4

                    Repeater {
                        model: {
                            const q = search.text.toLowerCase()
                            return q
                                ? root.emojis.filter(x => x.k.includes(q))
                                : root.emojis
                        }
                        delegate: Rectangle {
                            required property var modelData
                            width: 44; height: 44
                            radius: S.Theme.radiusSm
                            color: hover.containsMouse ? S.Theme.hover : "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: parent.modelData.e
                                font.pixelSize: 24
                            }
                            MouseArea {
                                id: hover
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    copy.command = ["sh", "-c", `printf '%s' '${parent.modelData.e}' | wl-copy`]
                                    copy.running = false; copy.running = true
                                    S.Visibilities.emoji = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Process { id: copy }
}
