import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Style
import "../components"

Item {
    anchors.fill:parent
    ColumnLayout {
        anchors.fill:parent;anchors.margins:30;spacing:18
        Column{spacing:4;Text{text:"Profile";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:30;font.weight:Font.Bold}Text{text:"Set a few defaults for your everyday monitoring routine.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:14}}
        AppCard {
            Layout.fillWidth:true;Layout.preferredHeight:330
            Column{anchors.fill:parent;anchors.margins:22;spacing:18
                Row{width:parent.width;height:72;spacing:14
                    Rectangle{width:64;height:64;radius:32;clip:true;Image{anchors.fill:parent;source:"../../assets/avatar.png";fillMode:Image.PreserveAspectCrop}}
                    Column{anchors.verticalCenter:parent.verticalCenter;spacing:3;Text{text:appState.preferences.profileName;color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:18;font.weight:Font.Bold}Text{text:"PostureFlow profile";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11}}
                }
                Column{width:parent.width;spacing:7;Text{text:"Name";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:12;font.weight:Font.DemiBold}TextField{objectName:"profileNameInput";width:parent.width;height:46;text:appState.preferences.profileName;maximumLength:80;onEditingFinished:{appState.setPreference("profileName",text);text=appState.preferences.profileName} font.family:Style.Theme.fontFamily;font.pixelSize:13;color:Style.Theme.textPrimary;leftPadding:14;background:Rectangle{radius:Style.Theme.controlRadius;color:"white";border.color:Style.Theme.border}}}
                Row{width:parent.width;spacing:18
                    Column{width:(parent.width-18)/2;spacing:7;Text{text:"Default monitoring goal";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:12;font.weight:Font.DemiBold}AppSelect{width:parent.width;model:["1 hour per day","2 hours per day","3 hours per day"];currentIndex:appState.preferences.goalIndex;onActivated:appState.setPreference("goalIndex",currentIndex)}}
                    Column{width:(parent.width-18)/2;spacing:7;Text{text:"Start week on";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:12;font.weight:Font.DemiBold}AppSelect{width:parent.width;model:["Monday","Sunday"];currentIndex:appState.preferences.weekStart;onActivated:appState.setPreference("weekStart",currentIndex)}}
                }
            }
        }
        AppCard{Layout.fillWidth:true;Layout.preferredHeight:90;cardColor:Style.Theme.goodSoft;strokeColor:"#DDEDC2";Text{anchors.fill:parent;anchors.margins:18;text:"Your monitoring goal is used for progress context only. PostureFlow does not treat it as a medical target.";wrapMode:Text.WordWrap;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:12;verticalAlignment:Text.AlignVCenter}}
        Item{Layout.fillHeight:true}
    }
}
