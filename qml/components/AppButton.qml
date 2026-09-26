import QtQuick
import QtQuick.Controls
import "../theme" as Style

Button {
    id: root
    property color baseColor: Style.Theme.sidebar
    property color hoverColor: Qt.lighter(baseColor, 1.08)
    property color textColor: "white"
    property color borderColor: "transparent"
    property int buttonRadius: Style.Theme.controlRadius
    implicitHeight: 46
    implicitWidth: 150
    padding: 12

    background: Rectangle {
        radius: root.buttonRadius
        color: root.enabled ? (root.down ? Qt.darker(root.baseColor, 1.04) : (root.hovered ? root.hoverColor : root.baseColor)) : "#ECEAE8"
        border.width: root.activeFocus ? 2 : (root.borderColor === "transparent" ? 0 : 1)
        border.color: root.activeFocus ? Style.Theme.brandAccent : root.borderColor
        Behavior on color { ColorAnimation { duration: 120 } }
    }
    contentItem: Text {
        text: root.text
        color: root.enabled ? root.textColor : Style.Theme.textMuted
        font.family: Style.Theme.fontFamily
        font.pixelSize: 14
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
