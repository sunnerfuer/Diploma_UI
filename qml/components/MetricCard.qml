import QtQuick
import QtQuick.Layouts
import "../theme" as Style

AppCard {
    id: root
    property string title: "METRIC"
    property string value: "82%"
    property string detail: ""
    property string footnote: ""
    property color accent: Style.Theme.lilac
    property color softColor: Style.Theme.lilacSoft
    property string iconText: "◉"
    cardColor: softColor
    strokeColor: Qt.rgba(accent.r, accent.g, accent.b, 0.28)

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 6
        Text {
            text: root.title
            color: "#3B3A66"
            font.family: Style.Theme.fontFamily
            font.pixelSize: 11
            font.weight: Font.Bold
            font.letterSpacing: 1.1
        }
        Row {
            width: parent.width
            spacing: 8
            Text {
                text: root.value
                color: Style.Theme.textPrimary
                font.family: Style.Theme.fontFamily
                font.pixelSize: 38
                font.weight: Font.Bold
                width: parent.width - 58
                elide: Text.ElideRight
            }
            Rectangle {
                width: 46; height: 46; radius: 23
                color: Qt.rgba(root.accent.r, root.accent.g, root.accent.b, 0.35)
                Text { anchors.centerIn: parent; text: root.iconText; font.pixelSize: 20; color: Style.Theme.textPrimary }
            }
        }
        Text {
            visible: root.detail.length > 0
            text: root.detail
            color: Style.Theme.textPrimary
            font.family: Style.Theme.fontFamily
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }
        Text {
            visible: root.footnote.length > 0
            text: root.footnote
            color: Style.Theme.textSecondary
            font.family: Style.Theme.fontFamily
            font.pixelSize: 13
            wrapMode: Text.WordWrap
            width: parent.width
        }
    }
}
