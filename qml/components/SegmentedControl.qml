import QtQuick
import QtQuick.Layouts
import "../theme" as Style

Rectangle {
    id: root
    property var options: ["Day", "Week", "Month"]
    property int currentIndex: 0
    signal selected(int index)
    implicitWidth: 280
    implicitHeight: 42
    radius: 13
    color: "#F1F0ED"
    border.color: Style.Theme.border

    Row {
        anchors.fill: parent
        anchors.margins: 3
        spacing: 0
        Repeater {
            model: root.options
            delegate: Rectangle {
                objectName: root.objectName + "-option-" + index
                width: (root.width - 6) / root.options.length
                height: root.height - 6
                radius: 11
                color: index === root.currentIndex ? "white" : "transparent"
                border.width: index === root.currentIndex ? 1 : 0
                border.color: Style.Theme.border
                Text {
                    anchors.centerIn: parent
                    text: modelData
                    color: index === root.currentIndex ? Style.Theme.textPrimary : Style.Theme.textSecondary
                    font.family: Style.Theme.fontFamily
                    font.pixelSize: 13
                    font.weight: index === root.currentIndex ? Font.DemiBold : Font.Normal
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.selected(index)
                }
            }
        }
    }
}
