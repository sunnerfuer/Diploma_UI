import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Style
import "../components"

Item {
    anchors.fill:parent
    property bool advancedOpen: false
    ColumnLayout {
        anchors.fill:parent;anchors.margins:28;spacing:12
        Column{spacing:4;Text{text:"Detection";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:30;font.weight:Font.Bold}Text{text:"Adjust how PostureFlow interprets your posture during monitoring.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:14}}
        AppCard {
            Layout.fillWidth:true;Layout.preferredHeight:98
            Column{anchors.fill:parent;anchors.margins:16;spacing:6
                Text{text:"Posture detection sensitivity";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:13;font.weight:Font.DemiBold}
                Slider{id:sensitivity;objectName:"sensitivitySlider";width:parent.width;height:28;from:0;to:100;stepSize:1;value:appState.preferences.sensitivity;onMoved:appState.setPreference("sensitivity",value)
                    background:Rectangle{x:sensitivity.leftPadding;y:sensitivity.topPadding+sensitivity.availableHeight/2-height/2;width:sensitivity.availableWidth;height:6;radius:3;color:"#E9E5F2";Rectangle{width:sensitivity.visualPosition*parent.width;height:parent.height;radius:3;color:"#A783F2"}}
                    handle:Rectangle{x:sensitivity.leftPadding+sensitivity.visualPosition*(sensitivity.availableWidth-width);y:sensitivity.topPadding+sensitivity.availableHeight/2-height/2;width:20;height:20;radius:10;color:"#9C77F0";border.color:"white";border.width:3}
                }
                Row{width:parent.width;Text{text:"Low";width:parent.width/2;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:10}Text{text:"High";width:parent.width/2;horizontalAlignment:Text.AlignRight;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:10}}
            }
        }
        AppCard {
            Layout.fillWidth:true;Layout.preferredHeight:72
            Row{anchors.fill:parent;anchors.margins:16
                Column{width:parent.width-70;spacing:3;Text{text:"Stable detection";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:13;font.weight:Font.DemiBold}Text{text:"Ignore very short posture changes.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11}}
                ToggleSwitch{checked:appState.preferences.stableDetection;anchors.verticalCenter:parent.verticalCenter;onToggled:checked => appState.setPreference("stableDetection",checked)}
            }
        }
        AppCard {
            Layout.fillWidth:true;Layout.preferredHeight:64
            Row{anchors.fill:parent;anchors.margins:14
                Text{text:"Minimum detection duration";width:parent.width-230;color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:13;font.weight:Font.DemiBold;anchors.verticalCenter:parent.verticalCenter}
                AppSelect{width:210;height:42;enabled:appState.preferences.stableDetection;model:["1 second","3 seconds","5 seconds"];currentIndex:appState.preferences.minimumDuration;onActivated:appState.setPreference("minimumDuration",currentIndex);anchors.verticalCenter:parent.verticalCenter}
            }
        }
        AppCard {
            Layout.fillWidth:true;Layout.preferredHeight:advancedOpen?130:56
            Column{anchors.fill:parent
                Rectangle{width:parent.width;height:56;color:"transparent"
                    Text{anchors.left:parent.left;anchors.leftMargin:16;anchors.verticalCenter:parent.verticalCenter;text:"Advanced settings";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:13;font.weight:Font.DemiBold}
                    Text{anchors.right:parent.right;anchors.rightMargin:16;anchors.verticalCenter:parent.verticalCenter;text:advancedOpen?"⌃":"⌄";font.pixelSize:18;color:Style.Theme.textPrimary}
                    MouseArea{anchors.fill:parent;cursorShape:Qt.PointingHandCursor;onClicked:advancedOpen=!advancedOpen}
                }
                Text{visible:advancedOpen;width:parent.width-32;x:16;text:"Model version: Demo UI bridge\nConfidence threshold and smoothing will be connected through the Python backend.";wrapMode:Text.WordWrap;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11;lineHeight:1.3}
            }
        }
        AppCard {
            Layout.fillWidth:true;Layout.preferredHeight:150
            Row{anchors.fill:parent;anchors.margins:18;spacing:14
                Rectangle{width:64;height:64;radius:32;color:Style.Theme.lilacSoft;Text{anchors.centerIn:parent;text:"♙";font.pixelSize:28;color:"#33275C"}}
                Column{width:parent.width-275;spacing:4;anchors.verticalCenter:parent.verticalCenter
                    Text{text:"Personal calibration";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:16;font.weight:Font.Bold}
                    Text{width:parent.width;text:"Calibrate PostureFlow for your usual neutral sitting position.";wrapMode:Text.WordWrap;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11}
                    Rectangle{width:parent.width;height:52;radius:12;color:Style.Theme.goodSoft
                        Row{anchors.fill:parent;anchors.margins:12;spacing:10;Rectangle{width:20;height:20;radius:10;color:Style.Theme.good;Text{anchors.centerIn:parent;text:appState.calibrated?"✓":"–";color:Style.Theme.textPrimary;font.pixelSize:13}}Column{spacing:2;Text{text:appState.calibrated?"Status: Calibrated":"Status: Not calibrated";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:11;font.weight:Font.DemiBold}Text{text:"Last calibration: "+appState.lastCalibration;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:10}}}
                    }
                }
                AppButton{objectName:"calibrateButton";width:170;text:appState.calibrated?"Recalibrate":"Calibrate";baseColor:Style.Theme.lime;hoverColor:"#E1F69A";textColor:Style.Theme.textPrimary;anchors.verticalCenter:parent.verticalCenter;onClicked:appState.startCalibration()}
            }
        }
        AppCard{Layout.fillWidth:true;Layout.preferredHeight:72;cardColor:Style.Theme.lilacSoft;strokeColor:"#E0D7F6";Text{anchors.fill:parent;anchors.margins:16;text:"ⓘ   Calibration helps PostureFlow learn your usual neutral sitting position, so it can more accurately detect when your posture changes during daily use.";wrapMode:Text.WordWrap;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11;verticalAlignment:Text.AlignVCenter}}
        Item{Layout.fillHeight:true}
    }
}
