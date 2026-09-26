import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Style
import "../components"

Item {
    id: root
    anchors.fill: parent
    ColumnLayout {
        anchors.fill:parent;anchors.margins:28;spacing:18
        RowLayout {
            Layout.fillWidth:true;Layout.preferredHeight:62
            Column{Layout.fillWidth:true;spacing:4
                Text{text:"Camera";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:30;font.weight:Font.Bold}
                Text{text:"Choose the camera used for posture monitoring.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:14}
            }
            Rectangle{Layout.preferredWidth:150;Layout.preferredHeight:42;radius:21;color:Style.Theme.goodSoft;Row{anchors.centerIn:parent;spacing:8;Text{text:"▣";font.pixelSize:16}Text{text:"Camera ready";font.family:Style.Theme.fontFamily;font.pixelSize:12;font.weight:Font.DemiBold}}}
        }

        RowLayout {
            Layout.fillWidth:true;Layout.fillHeight:true;spacing:22
            ColumnLayout {
                Layout.fillWidth:true;Layout.preferredWidth:520;Layout.fillHeight:true;spacing:10
                Text{text:"Camera device";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:13;font.weight:Font.DemiBold}
                AppSelect{objectName:"cameraSelect";Layout.fillWidth:true;Layout.preferredHeight:48;model:["Integrated Webcam (demo)","External USB Camera (demo)"];currentIndex:appState.preferences.cameraIndex;onActivated:appState.setPreference("cameraIndex",currentIndex)}
                Item{height:4;width:1}
                Text{text:"Camera preview";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:13;font.weight:Font.DemiBold}
                WebcamPreview{Layout.fillWidth:true;Layout.fillHeight:true;Layout.minimumHeight:300;Layout.maximumHeight:360;postureKey:"good";skeletonVisible:appState.skeletonVisible;mirrored:appState.preferences.mirrorCamera;frameSource:appState.cameraSource;cameraLabel:appState.preferences.cameraIndex===0?"Integrated Webcam":"External USB Camera";live:false;onSkeletonToggled:checked => appState.setSkeletonVisible(checked)}
            }
            ColumnLayout {
                Layout.preferredWidth:280;Layout.fillHeight:true;spacing:16
                AppCard {
                    Layout.fillWidth:true;Layout.preferredHeight:270;cardColor:Style.Theme.canvas
                    Column{anchors.fill:parent;anchors.margins:20;spacing:20
                        Text{text:"Camera settings";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:15;font.weight:Font.Bold}
                        Row{width:parent.width;height:62;spacing:14
                            Column{width:parent.width-62;spacing:5;Text{text:"Mirror camera";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:13;font.weight:Font.DemiBold}Text{width:parent.width;wrapMode:Text.WordWrap;text:"Shows a mirrored image (like in a mirror)";color:Style.Theme.textMuted;font.family:Style.Theme.fontFamily;font.pixelSize:11}}
                            ToggleSwitch{objectName:"mirrorToggle";checked:appState.preferences.mirrorCamera;anchors.verticalCenter:parent.verticalCenter;onToggled:checked => appState.setPreference("mirrorCamera",checked)}
                        }
                        Row{width:parent.width;height:70;spacing:14
                            Column{width:parent.width-62;spacing:5;Text{width:parent.width;wrapMode:Text.WordWrap;text:"Show posture skeleton";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:13;font.weight:Font.DemiBold}Text{width:parent.width;wrapMode:Text.WordWrap;text:"Display a simple posture guide in the camera preview";color:Style.Theme.textMuted;font.family:Style.Theme.fontFamily;font.pixelSize:11}}
                            ToggleSwitch{objectName:"skeletonToggle";checked:appState.skeletonVisible;anchors.verticalCenter:parent.verticalCenter;onToggled:checked => appState.setSkeletonVisible(checked)}
                        }
                    }
                }
                AppCard {
                    Layout.fillWidth:true;Layout.preferredHeight:110;cardColor:Style.Theme.lilacSoft;strokeColor:"#E0D7F6"
                    Row{anchors.fill:parent;anchors.margins:18;spacing:14
                        Rectangle{width:42;height:42;radius:21;color:"#DACEFA";Text{anchors.centerIn:parent;text:"ⓘ";font.pixelSize:19;color:"#3E3471"}}
                        Column{width:parent.width-60;spacing:4;Text{text:"Good lighting helps";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:13;font.weight:Font.DemiBold}Text{width:parent.width;text:"Make sure your upper body and shoulders are clearly visible for the best results.";wrapMode:Text.WordWrap;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11;lineHeight:1.2}}
                    }
                }
                Item{Layout.fillHeight:true}
            }
        }
    }
}
