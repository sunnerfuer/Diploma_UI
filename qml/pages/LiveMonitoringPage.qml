import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Style
import "../components"

PageScaffold {
    id: root
    clip: true
    contentWidth: width
    contentHeight: Math.max(height, content.implicitHeight + Style.Theme.pagePadding * 2)

    ColumnLayout {
        id: content
        x: Style.Theme.pagePadding
        y: 14
        width: root.width - Style.Theme.pagePadding * 2
        spacing: 16

        PageHeader {
            Layout.fillWidth: true
            title: "Live Monitoring"
            subtitle: "Demo preview · Explore your posture and session feedback."
        }

        RowLayout {
            Layout.fillWidth:true
            Text{text:"Demo posture";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:12}
            SegmentedControl {
                objectName:"demoPostureControl"
                Layout.preferredWidth:460
                options:["Good posture  1","Leaning forward  2","Leaning left  3"]
                currentIndex:["good","forward","left"].indexOf(appState.postureKey)
                enabled:appState.monitoringActive
                opacity:enabled?1:.5
                onSelected:index => appState.setPostureState(["good","forward","left"][index])
            }
            Item{Layout.fillWidth:true}
            Text{text:"Space · Pause / Resume";color:Style.Theme.textMuted;font.family:Style.Theme.fontFamily;font.pixelSize:11}
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 485
            spacing: 16

            AppCard {
                Layout.fillWidth: true
                Layout.preferredWidth: 760
                Layout.fillHeight: true
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12
                    WebcamPreview {
                        id: webcam
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        postureKey: appState.postureKey
                        skeletonVisible: appState.skeletonVisible
                        live: appState.monitoringActive
                        paused: appState.monitoringState === "paused"
                        mirrored: appState.preferences.mirrorCamera
                        frameSource: appState.cameraSource
                        cameraLabel: appState.preferences.cameraIndex===0?"Integrated Webcam":"External USB Camera"
                        onSkeletonToggled: checked => appState.setSkeletonVisible(checked)
                    }
                    MonitoringControls {
                        Layout.fillWidth: true
                        monitoringState: appState.monitoringState
                        onStartRequested: appState.startMonitoring()
                        onPauseRequested: appState.pauseMonitoring()
                        onResumeRequested: appState.resumeMonitoring()
                        onEndRequested: appState.endMonitoring()
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.preferredWidth: 345
                Layout.fillHeight: true
                spacing: 12

                PostureStatusCard {
                    id: postureCard
                    Layout.fillWidth: true
                    Layout.preferredHeight: 170
                    postureKey: appState.postureKey
                    postureLabel: appState.postureLabel
                    message: appState.postureMessage
                    confidence: appState.confidence
                    monitoringState: appState.monitoringState
                }

                AppCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 180
                    cardColor: Style.Theme.sidebar
                    strokeColor: Style.Theme.sidebar
                    Column {
                        anchors.fill:parent;anchors.margins:18;spacing:7
                        Text{text:"SESSION";color:"#D7D6DF";font.family:Style.Theme.fontFamily;font.pixelSize:10;font.weight:Font.Bold;font.letterSpacing:1.2}
                        Text{text:appState.elapsedText;color:"white";font.family:Style.Theme.fontFamily;font.pixelSize:35;font.weight:Font.Bold}
                        Text{text:appState.monitoringState==="not_started"?"Ready for a new session":"Started at "+appState.sessionStarted;color:"#B9B8C2";font.family:Style.Theme.fontFamily;font.pixelSize:12}
                        Rectangle{width:parent.width;height:1;color:"#20FFFFFF"}
                        Row{width:parent.width;height:48
                            Column{width:parent.width/2;spacing:4
                                Row{spacing:7;Rectangle{width:9;height:9;radius:5;color:Style.Theme.good;anchors.verticalCenter:parent.verticalCenter}Text{text:"Good posture";color:"#D7D6DF";font.family:Style.Theme.fontFamily;font.pixelSize:10}}
                                Text{text:appState.goodMinutes+" min";color:"white";font.family:Style.Theme.fontFamily;font.pixelSize:17;font.weight:Font.DemiBold}
                            }
                            Rectangle{width:1;height:40;color:"#20FFFFFF"}
                            Column{width:parent.width/2-1;spacing:4
                                Row{spacing:7;Rectangle{width:9;height:9;radius:5;color:Style.Theme.peach;anchors.verticalCenter:parent.verticalCenter}Text{text:"Corrections";color:"#D7D6DF";font.family:Style.Theme.fontFamily;font.pixelSize:10}}
                                Text{text:appState.correctionCount;color:"white";font.family:Style.Theme.fontFamily;font.pixelSize:17;font.weight:Font.DemiBold}
                            }
                        }
                    }
                }

                AppCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Column {
                        anchors.fill:parent;anchors.margins:16;spacing:8
                        Text{text:"POSTURE TIP";color:"#74778A";font.family:Style.Theme.fontFamily;font.pixelSize:10;font.weight:Font.Bold;font.letterSpacing:1}
                        Row{width:parent.width;spacing:12
                            Rectangle{width:48;height:48;radius:13;color:Style.Theme.lilacSoft;Text{anchors.centerIn:parent;text:"☼";font.pixelSize:24;color:Style.Theme.textPrimary}}
                            Text{width:parent.width-60;text:appState.postureTip;color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:11;wrapMode:Text.WordWrap;lineHeight:1.2}
                        }
                    }
                }
            }
        }

        AppCard {
            Layout.fillWidth: true
            Layout.preferredHeight: 185
            RowLayout {
                anchors.fill:parent;anchors.margins:16;spacing:18
                ColumnLayout {
                    Layout.fillWidth:true;Layout.preferredWidth:720;Layout.fillHeight:true;spacing:6
                    RowLayout { Layout.fillWidth:true
                        Text{text:"Session Timeline";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:18;font.weight:Font.Bold;Layout.fillWidth:true}
                        AppSelect{Layout.preferredWidth:160;model:["Posture Events"];currentIndex:0}
                    }
                    SessionTimeline { Layout.fillWidth:true;Layout.fillHeight:true;markers:appState.sessionMarkers;startLabel:appState.monitoringState==="not_started"?"—":appState.sessionStarted;endLabel:appState.monitoringState==="not_started"?"—":appState.sessionEnd }
                }
                Rectangle{Layout.fillHeight:true;width:1;color:Style.Theme.border}
                ColumnLayout {
                    Layout.preferredWidth:330;Layout.fillHeight:true;spacing:7
                    Text{text:"Recent Events";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:15;font.weight:Font.Bold;Layout.fillWidth:true}
                    Text{visible:appState.recentEvents.length===0;text:"Your session events will appear here.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11}
                    Repeater {
                        model: appState.recentEvents
                        delegate: RowLayout {
                            Layout.fillWidth:true;height:25;spacing:8
                            Rectangle{width:10;height:10;radius:5;color:Style.Theme.postureColor(modelData.key)}
                            Text{text:modelData.time;color:"#657095";font.family:Style.Theme.fontFamily;font.pixelSize:10;Layout.preferredWidth:42}
                            Text{text:modelData.label;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:10;Layout.fillWidth:true}
                            Text{text:modelData.detail;Layout.maximumWidth:100;elide:Text.ElideRight;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:10}
                        }
                    }
                }
            }
        }
    }
}
