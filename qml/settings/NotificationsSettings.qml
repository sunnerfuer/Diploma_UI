import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Style
import "../components"

Item {
    anchors.fill: parent
    ColumnLayout {
        anchors.fill:parent;anchors.margins:30;spacing:18
        Column{spacing:4;Text{text:"Notifications";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:30;font.weight:Font.Bold}Text{text:"Choose how PostureFlow reminds you to make small adjustments.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:14}}
        AppCard {
            Layout.fillWidth:true;Layout.preferredHeight:345
            Column{anchors.fill:parent;anchors.margins:20;spacing:0
                Row{width:parent.width;height:68
                    Column{width:parent.width-70;spacing:4;Text{text:"Posture reminders";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:14;font.weight:Font.DemiBold}Text{text:"Get a gentle reminder when a correction may help.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11}}
                    ToggleSwitch{objectName:"remindersToggle";checked:appState.preferences.reminders;anchors.verticalCenter:parent.verticalCenter;onToggled:checked => appState.setPreference("reminders",checked)}
                }
                Rectangle{width:parent.width;height:1;color:Style.Theme.border}
                Row{width:parent.width;height:82
                    Column{width:parent.width-210;spacing:4;Text{width:parent.width;wrapMode:Text.WordWrap;text:"Notify me when poor posture persists for";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:14;font.weight:Font.DemiBold}Text{text:"Short posture changes are ignored.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11}}
                    AppSelect{width:190;height:44;enabled:appState.preferences.reminders;anchors.verticalCenter:parent.verticalCenter;model:["5 seconds","10 seconds","15 seconds","30 seconds"];currentIndex:appState.preferences.reminderDelay;onActivated:appState.setPreference("reminderDelay",currentIndex)}
                }
                Rectangle{width:parent.width;height:1;color:Style.Theme.border}
                Row{width:parent.width;height:68
                    Column{width:parent.width-70;spacing:4;Text{text:"Notification sound";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:14;font.weight:Font.DemiBold}Text{text:"Play a quiet sound with posture reminders.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11}}
                    ToggleSwitch{checked:appState.preferences.sound;anchors.verticalCenter:parent.verticalCenter;onToggled:checked => appState.setPreference("sound",checked)}
                }
                Rectangle{width:parent.width;height:1;color:Style.Theme.border}
                Row{width:parent.width;height:68
                    Column{width:parent.width-70;spacing:4;Text{text:"Desktop notifications";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:14;font.weight:Font.DemiBold}Text{text:"Allow PostureFlow to show system notifications.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11}}
                    ToggleSwitch{checked:appState.preferences.desktop;anchors.verticalCenter:parent.verticalCenter;onToggled:checked => appState.setPreference("desktop",checked)}
                }
            }
        }
        AppCard{Layout.fillWidth:true;Layout.preferredHeight:95;cardColor:Style.Theme.goodSoft;strokeColor:"#DDEDC2";Text{anchors.fill:parent;anchors.margins:18;text:"Reminders are designed to be supportive, not distracting. PostureFlow waits for a posture state to persist before notifying you.";wrapMode:Text.WordWrap;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:12;verticalAlignment:Text.AlignVCenter}}
        Item{Layout.fillHeight:true}
    }
}
