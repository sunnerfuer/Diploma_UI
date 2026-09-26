import QtQuick
import "../theme" as Style

Item {
    id: root
    property string label: "Good posture"
    property real value: 76
    property color accent: Style.Theme.good
    implicitHeight: 42

    Row {
        anchors.top: parent.top
        width: parent.width
        spacing: 10
        Rectangle { width: 10; height: 10; radius: 5; color: root.accent; anchors.verticalCenter: parent.verticalCenter }
        Text {
            text: root.label
            color: Style.Theme.textPrimary
            font.family: Style.Theme.fontFamily
            font.pixelSize: 13
            width: parent.width - 80
        }
        Text {
            text: Math.round(root.value) + "%"
            color: Style.Theme.textPrimary
            font.family: Style.Theme.fontFamily
            font.pixelSize: 13
            font.weight: Font.Bold
        }
    }
    Rectangle {
        x: 20; y: 24
        width: root.width - 20
        height: 8
        radius: 4
        color: "#EEEFF2"
        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, root.value / 100))
            height: parent.height
            radius: parent.radius
            color: root.accent
        }
    }
}
