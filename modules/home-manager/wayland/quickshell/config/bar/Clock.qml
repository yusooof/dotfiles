import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../services" as S

Item {
    id: root
    implicitWidth: label.implicitWidth + 12
    implicitHeight: label.implicitHeight + 4

    SystemClock { id: clock; precision: SystemClock.Seconds }

    Text {
        id: label
        anchors.centerIn: parent
        color: S.Theme.fg
        font.family: S.Theme.fontFamily
        font.pixelSize: S.Theme.fontSize
        font.weight: Font.DemiBold
        text: Qt.formatDateTime(clock.date, "ddd MMM d  HH:mm")
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: popup.visible ? popup.close() : popup.open()
    }

    Popup {
        id: popup
        x: -20
        y: parent.height + 6
        padding: S.Theme.padding + 2
        background: Rectangle {
            color: S.Theme.panelBg2
            border.color: S.Theme.border
            border.width: 1
            radius: S.Theme.radius
        }
        contentItem: ColumnLayout {
            spacing: S.Theme.gap
            Text {
                Layout.alignment: Qt.AlignHCenter
                color: S.Theme.fg
                font.family: S.Theme.fontFamily
                font.pixelSize: S.Theme.fontSizeLg
                font.weight: Font.DemiBold
                text: Qt.formatDate(clock.date, "MMMM yyyy")
            }
            // 7-column day grid built by hand (no Qt.labs.calendar dep).
            Grid {
                Layout.alignment: Qt.AlignHCenter
                columns: 7
                rowSpacing: 2
                columnSpacing: 2

                Repeater {
                    model: ["S","M","T","W","T","F","S"]
                    delegate: Text {
                        required property string modelData
                        width: 28; height: 22
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: modelData
                        color: S.Theme.fgFaint
                        font.family: S.Theme.fontFamily
                        font.pixelSize: S.Theme.fontSizeSm
                        font.weight: Font.DemiBold
                    }
                }

                Repeater {
                    // 42 cells = 6 weeks. First-of-month offset, last-of-month wraps.
                    model: 42
                    delegate: Item {
                        required property int index
                        readonly property date today: clock.date
                        readonly property date first: new Date(today.getFullYear(), today.getMonth(), 1)
                        readonly property int offset: first.getDay()
                        readonly property int day: index - offset + 1
                        readonly property int dim: new Date(today.getFullYear(), today.getMonth() + 1, 0).getDate()
                        readonly property bool inMonth: day >= 1 && day <= dim
                        readonly property bool isToday: inMonth && day === today.getDate()

                        width: 28; height: 24
                        Rectangle {
                            anchors.centerIn: parent
                            visible: parent.isToday
                            width: 22; height: 22; radius: 11
                            color: S.Theme.accent
                        }
                        Text {
                            anchors.centerIn: parent
                            text: parent.inMonth ? parent.day : ""
                            color: parent.isToday ? S.Theme.bg
                                : parent.inMonth ? S.Theme.fg
                                : S.Theme.fgFaint
                            font.family: S.Theme.fontFamily
                            font.pixelSize: S.Theme.fontSize
                        }
                    }
                }
            }
        }
    }
}
