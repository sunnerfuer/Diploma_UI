import QtQuick
import "../theme" as Style

Item {
    id: root
    property bool checked: true
    signal toggled(bool checked)
    implicitWidth: 48
    implicitHeight: 28
    activeFocusOnTab: true
    Accessible.role: Accessible.CheckBox
    Accessible.checked: checked
    Keys.onSpacePressed: root.toggled(!root.checked)

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: root.checked ? Style.Theme.lime : "#DDDCE1"
        Behavior on color { ColorAnimation { duration: 140 } }
    }
    Rectangle {
        width: 22; height: 22; radius: 11
        y: 3
        x: root.checked ? root.width - width - 3 : 3
        color: "white"
        border.color: root.activeFocus ? Style.Theme.lilac : "#10000000"
        Behavior on x { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.toggled(!root.checked)
        }
    }
}
