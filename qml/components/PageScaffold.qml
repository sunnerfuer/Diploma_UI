import QtQuick
import QtQuick.Controls
import "../theme" as Style

Flickable {
    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.VerticalFlick
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
        width: 8
        contentItem: Rectangle {
            implicitWidth: 5
            radius: 3
            color: Style.Theme.textMuted
            opacity: parent.active ? .7 : .25
            Behavior on opacity { NumberAnimation { duration: 140 } }
        }
    }
}
