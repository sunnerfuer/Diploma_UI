import QtQuick
import "../theme" as Style

Column {
    id: root
    property string selected: "camera"
    signal choose(string key)
    spacing: 4

    Repeater {
        model: [
            {key:"camera", icon:"▣", label:"Camera"},
            {key:"notifications", icon:"♧", label:"Notifications"},
            {key:"detection", icon:"☷", label:"Detection"},
            {key:"appearance", icon:"◉", label:"Appearance"},
            {key:"profile", icon:"♙", label:"Profile"}
        ]
        delegate: Rectangle {
            width: root.width
            height: 52
            radius: 13
            color: root.selected === modelData.key ? Style.Theme.brandSoft : (ma.containsMouse ? Style.Theme.canvas : "transparent")
            Row {
                anchors.fill:parent;anchors.leftMargin:16;spacing:15
                Text { text:modelData.icon;color:Style.Theme.textPrimary;font.pixelSize:20;anchors.verticalCenter:parent.verticalCenter;width:24;horizontalAlignment:Text.AlignHCenter }
                Text { text:modelData.label;color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:14;font.weight:root.selected===modelData.key?Font.DemiBold:Font.Normal;anchors.verticalCenter:parent.verticalCenter }
            }
            MouseArea { id:ma;anchors.fill:parent;hoverEnabled:true;cursorShape:Qt.PointingHandCursor;onClicked:root.choose(modelData.key) }
        }
    }
}
