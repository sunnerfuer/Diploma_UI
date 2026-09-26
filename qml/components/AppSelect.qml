import QtQuick
import QtQuick.Controls
import "../theme" as Style

ComboBox {
    id: root
    implicitHeight: 44
    font.family: Style.Theme.fontFamily
    font.pixelSize: 13
    leftPadding: 14
    rightPadding: 34

    background: Rectangle {
        radius: Style.Theme.controlRadius
        color: "white"
        border.color: root.activeFocus ? Style.Theme.brandAccent : Style.Theme.border
        border.width: 1
    }
    contentItem: Text {
        leftPadding: 0
        rightPadding: 0
        text: root.displayText
        font: root.font
        color: Style.Theme.textPrimary
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    indicator: Text {
        text: "⌄"
        color: Style.Theme.textPrimary
        font.family: Style.Theme.fontFamily
        font.pixelSize: 18
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.verticalCenter: parent.verticalCenter
    }
    popup: Popup {
        y: root.height + 5
        width: root.width
        implicitHeight: contentItem.implicitHeight + 8
        padding: 4
        background: Rectangle {
            radius: 12
            color: "white"
            border.color: Style.Theme.border
        }
        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: root.delegateModel
            currentIndex: root.highlightedIndex
        }
    }
    delegate: ItemDelegate {
        width: root.width - 8
        height: 38
        highlighted: root.highlightedIndex === index
        contentItem: Text {
            text: modelData
            color: Style.Theme.textPrimary
            font.family: Style.Theme.fontFamily
            font.pixelSize: 13
            verticalAlignment: Text.AlignVCenter
            leftPadding: 10
        }
        background: Rectangle {
            radius: 9
            color: root.highlightedIndex === index ? Style.Theme.brandSoft : "transparent"
        }
    }
}
