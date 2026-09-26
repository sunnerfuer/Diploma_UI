import QtQuick
import "../theme" as Style

AppCard {
    id: root
    property string postureKey: "good"
    property string postureLabel: "GOOD POSTURE"
    property string message: "Your position looks balanced."
    property int confidence: 92
    property string monitoringState: "active"
    property color accent: Style.Theme.postureColor(postureKey)
    cardColor: Style.Theme.postureSoftColor(postureKey)
    strokeColor: Qt.rgba(accent.r, accent.g, accent.b, 0.32)

    Column {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 9
        Text {
            text: "CURRENT POSTURE"
            color: "#64647A"
            font.family: Style.Theme.fontFamily; font.pixelSize: 10; font.weight: Font.Bold; font.letterSpacing: 1.0
        }
        Row {
            width: parent.width
            spacing: 10
            Rectangle { width: 18; height: 18; radius: 9; color: root.accent; anchors.verticalCenter: parent.verticalCenter }
            Text {
                text: root.monitoringState === "not_started" ? "READY TO START" : root.postureLabel
                width: parent.width - 28
                fontSizeMode: Text.Fit
                minimumPixelSize: 16
                color: Style.Theme.textPrimary
                font.family: Style.Theme.fontFamily; font.pixelSize: 22; font.weight: Font.Bold
            }
        }
        Text {
            text: root.monitoringState === "not_started" ? "Start a session to see your posture." : root.message
            width: parent.width
            color: Style.Theme.textSecondary
            font.family: Style.Theme.fontFamily; font.pixelSize: 12
            wrapMode: Text.WordWrap
        }
        Rectangle {
            width: parent.width; height: 7; radius: 4; color: "#66FFFFFF"
            Rectangle { height: parent.height; radius: parent.radius; width: parent.width * root.confidence / 100; color: root.accent }
        }
        Row {
            width: parent.width
            Text { text: root.monitoringState === "paused" ? "Detection paused" : (root.monitoringState === "not_started" ? "Waiting for session" : (root.confidence >= 80 ? "Detection stable" : "Adjust your position")); color: Style.Theme.textSecondary; font.family: Style.Theme.fontFamily; font.pixelSize: 12; width: parent.width - 48 }
            Text { text: root.monitoringState === "not_started" ? "—" : root.confidence + "%"; color: Style.Theme.textPrimary; font.family: Style.Theme.fontFamily; font.pixelSize: 13; font.weight: Font.Bold }
        }
    }
}
