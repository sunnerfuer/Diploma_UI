import QtQuick
import QtQuick.Effects
import "../theme" as Style

Rectangle {
    id: root
    property color cardColor: Style.Theme.surface
    property color strokeColor: Style.Theme.border
    property int cardRadius: Style.Theme.cardRadius
    property bool softShadow: true
    color: cardColor
    radius: cardRadius
    border.color: strokeColor
    border.width: Style.Theme.borderWidth
    layer.enabled: softShadow && GraphicsInfo.api !== GraphicsInfo.Software
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Style.Theme.shadowColor
        shadowBlur: Style.Theme.shadowBlur
        shadowVerticalOffset: Style.Theme.shadowYOffset
    }
}
