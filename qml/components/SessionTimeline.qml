import QtQuick
import "../theme" as Style

Item {
    id: root
    property bool compact: false
    property string startLabel: "—"
    property string endLabel: "—"
    property var markers: []

    Rectangle {
        id: track
        x: 6; y: compact ? 40 : 52
        width: root.width - 12
        height: compact ? 18 : 10
        radius: height/2
        color: compact ? Style.Theme.good : "#F1F1F2"
    }
    Repeater {
        model: root.markers
        delegate: Rectangle {
            width: compact ? 26 : 4
            height: compact ? track.height : 18
            radius: compact ? 0 : 2
            x: track.x + track.width * modelData.p - width/2
            y: compact ? track.y : track.y - 4
            color: Style.Theme.postureColor(modelData.key)
        }
    }
    Text { text: root.startLabel; x:0; y:track.y+track.height+10; color:Style.Theme.textSecondary; font.family:Style.Theme.fontFamily; font.pixelSize:10 }
    Text { text: root.endLabel; anchors.right:parent.right; y:track.y+track.height+10; color:"#69708D"; font.family:Style.Theme.fontFamily; font.pixelSize:10 }

    Row {
        visible: !root.compact
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        spacing: 24
        Repeater {
            model:[{k:"good",t:"Good posture"},{k:"forward",t:"Leaning forward"},{k:"left",t:"Leaning left"}]
            delegate: Row {
                spacing:6
                Rectangle { width:10;height:10;radius:5;color:Style.Theme.postureColor(modelData.k);anchors.verticalCenter:parent.verticalCenter }
                Text { text:modelData.t;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:10 }
            }
        }
    }
}
