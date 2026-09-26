import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Style
import "../components"

Item {
    anchors.fill:parent
    readonly property int themeIndex:appState.preferences.themeIndex
    readonly property int accentIndex:appState.preferences.accentIndex
    readonly property int densityIndex:appState.preferences.densityIndex
    ColumnLayout {
        anchors.fill:parent;anchors.margins:30;spacing:18
        Column{spacing:4;Text{text:"Appearance";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:30;font.weight:Font.Bold}Text{text:"Personalize the interface while keeping PostureFlow calm and easy to read.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:14}}
        AppCard {
            Layout.fillWidth:true;Layout.preferredHeight:195
            Column{anchors.fill:parent;anchors.margins:20;spacing:14
                Text{text:"Theme";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:14;font.weight:Font.Bold}
                Row{width:parent.width;spacing:12
                    Repeater{model:["Light","Dark","System"];delegate:Rectangle{width:(parent.width-24)/3;height:82;radius:14;opacity:index===0?1:0.45;color:themeIndex===index?Style.Theme.brandSoft:Style.Theme.canvas;border.color:themeIndex===index?Style.Theme.brandAccent:Style.Theme.border
                        Column{anchors.centerIn:parent;spacing:7;Rectangle{width:34;height:24;radius:7;color:index===0?"white":(index===1?Style.Theme.sidebar:"#E8E7E4");border.color:Style.Theme.border}Text{text:modelData;color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:12;font.weight:themeIndex===index?Font.DemiBold:Font.Normal;anchors.horizontalCenter:parent.horizontalCenter}}
                        MouseArea{anchors.fill:parent;enabled:index===0;cursorShape:Qt.PointingHandCursor;onClicked:appState.setPreference("themeIndex",index)}
                    }}
                }
                Text{text:"Light theme is available in this demo. Dark and System are coming later.";font.family:Style.Theme.fontFamily;font.pixelSize:11;color:Style.Theme.textSecondary}
            }
        }
        AppCard {
            Layout.fillWidth:true;Layout.preferredHeight:150
            Column{anchors.fill:parent;anchors.margins:20;spacing:14
                Text{text:"Accent style";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:14;font.weight:Font.Bold}
                Row{spacing:14
                    Repeater{model:[{n:"Soft lilac",c:Style.Theme.lilac},{n:"Lime",c:Style.Theme.lime},{n:"Peach",c:Style.Theme.peach}];delegate:Rectangle{width:165;height:72;radius:14;color:accentIndex===index?"#FAF8FF":"#FBFAF8";border.color:accentIndex===index?modelData.c:Style.Theme.border
                        Row{anchors.centerIn:parent;spacing:10;Rectangle{width:24;height:24;radius:12;color:modelData.c}Text{text:modelData.n;color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:12}}
                        MouseArea{anchors.fill:parent;cursorShape:Qt.PointingHandCursor;onClicked:appState.setPreference("accentIndex",index)}
                    }}
                }
            }
        }
        AppCard {
            Layout.fillWidth:true;Layout.preferredHeight:135
            Column{anchors.fill:parent;anchors.margins:20;spacing:14
                Text{text:"Interface density";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:14;font.weight:Font.Bold}
                SegmentedControl{width:340;options:["Comfortable","Compact"];currentIndex:densityIndex;onSelected:index => appState.setPreference("densityIndex",index)}
                Text{text:"Comfortable spacing matches the approved desktop layout.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11}
            }
        }
        Item{Layout.fillHeight:true}
    }
}
