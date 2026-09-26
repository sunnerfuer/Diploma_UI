import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Style
import "../components"

PageScaffold {
    id: root
    readonly property var monthStats: appState.statisticsSnapshot("month")
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
            title: "Dashboard"
            subtitle: "Here’s your posture overview for today."
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16
            Layout.preferredHeight: 250

            AppCard {
                Layout.fillWidth: true
                Layout.preferredWidth: 430
                Layout.fillHeight: true
                cardColor: Style.Theme.lilacSoft
                strokeColor: "#DED2F7"
                Column {
                    anchors.fill: parent; anchors.margins: 20; spacing: 5
                    Text { text:"TODAY'S POSTURE"; color:"#443A76"; font.family:Style.Theme.fontFamily; font.pixelSize:11; font.weight:Font.Bold; font.letterSpacing:1.1 }
                    Text { text:appState.dashboardSummary.score+"%"; color:Style.Theme.textPrimary; font.family:Style.Theme.fontFamily; font.pixelSize:50; font.weight:Font.Bold }
                    Text { text:"Good overall"; color:Style.Theme.textPrimary; font.family:Style.Theme.fontFamily; font.pixelSize:16; font.weight:Font.DemiBold }
                    Text { text:"↑  6% from yesterday"; color:"#4FA51E"; font.family:Style.Theme.fontFamily; font.pixelSize:13; font.weight:Font.DemiBold }
                    Canvas {
                        width: parent.width; height: 54
                        onPaint: {
                            var c=getContext("2d");c.clearRect(0,0,width,height);c.strokeStyle="#8C67EA";c.lineWidth=2.2
                            var v=[31,29,35,31,29,34,32,36,40,37,43,49,47,55,60,62]
                            c.beginPath(); for(var i=0;i<v.length;i++){var x=i*width/(v.length-1),y=height-(v[i]-20)*1.2;if(i===0)c.moveTo(x,y);else c.lineTo(x,y)} c.stroke()
                            c.beginPath();c.arc(width-2,height-(v[v.length-1]-20)*1.2,4,0,Math.PI*2);c.fillStyle="#7651D8";c.fill()
                        }
                    }
                    Text { width:parent.width;wrapMode:Text.WordWrap;text:"You’re spending more time in a neutral position."; color:Style.Theme.textSecondary; font.family:Style.Theme.fontFamily; font.pixelSize:12 }
                }
            }

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: 305
                spacing: 14
                AppCard {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    cardColor: Style.Theme.goodSoft; strokeColor: "#DDEDC2"
                    Row {
                        anchors.fill: parent; anchors.margins: 18; spacing: 12
                        Column { width: parent.width-95; spacing:5
                            Text { text:"GOOD POSTURE"; color:"#455261"; font.family:Style.Theme.fontFamily; font.pixelSize:10; font.weight:Font.Bold; font.letterSpacing:1 }
                            Text { text:appState.dashboardSummary.goodTime; color:Style.Theme.textPrimary; font.family:Style.Theme.fontFamily; font.pixelSize:32; font.weight:Font.Bold }
                            Text { text:appState.dashboardSummary.goodPercent+"% of monitored time"; color:Style.Theme.textSecondary; font.family:Style.Theme.fontFamily; font.pixelSize:12 }
                        }
                        CircularProgress { width:74;height:74;value:.76;accent:"#70B623";track:"#DAEABF";strokeWidth:8; anchors.verticalCenter:parent.verticalCenter
                            Text { anchors.centerIn:parent;text:"76%";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:16;font.weight:Font.Bold }
                        }
                    }
                }
                AppCard {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    cardColor: Style.Theme.forwardSoft; strokeColor:"#F2CDBE"
                    Row {
                        anchors.fill:parent; anchors.margins:18
                        Column { width:parent.width-70; spacing:4
                            Text { text:"CORRECTIONS"; color:"#5D4B4B"; font.family:Style.Theme.fontFamily; font.pixelSize:10; font.weight:Font.Bold; font.letterSpacing:1 }
                            Text { text:appState.dashboardSummary.corrections; color:Style.Theme.textPrimary; font.family:Style.Theme.fontFamily; font.pixelSize:34; font.weight:Font.Bold }
                            Text { text:"↓  4 fewer than yesterday"; color:"#398F27"; font.family:Style.Theme.fontFamily; font.pixelSize:12 }
                        }
                        Rectangle { width:48;height:48;radius:24;color:"#F7C6B3";anchors.verticalCenter:parent.verticalCenter
                            Text { anchors.centerIn:parent;text:"✎";font.pixelSize:22;color:Style.Theme.textPrimary }
                        }
                    }
                }
            }

            AppCard {
                Layout.fillWidth: true
                Layout.preferredWidth: 290
                Layout.fillHeight: true
                cardColor: Style.Theme.sidebar
                strokeColor: Style.Theme.sidebar
                Column {
                    anchors.fill: parent; anchors.margins: 20; spacing: 9
                    Text { text:"CURRENT SESSION"; color:"#DAD9E1"; font.family:Style.Theme.fontFamily; font.pixelSize:10; font.weight:Font.Bold; font.letterSpacing:1.2 }
                    Text { text:appState.monitoringState==="not_started"?"Ready":appState.elapsedMinutes+" min"; color:"white"; font.family:Style.Theme.fontFamily; font.pixelSize:36; font.weight:Font.Bold }
                    Row { spacing:8; Rectangle{width:11;height:11;radius:6;color:Style.Theme.postureColor(appState.postureKey);anchors.verticalCenter:parent.verticalCenter} Text{text:appState.monitoringState==="paused"?"Paused":(appState.monitoringState==="not_started"?"Start a session":appState.postureLabel.toLowerCase());color:"#E6E5EA";font.family:Style.Theme.fontFamily;font.pixelSize:14} }
                    AppButton { width:parent.width;height:42;text:"Open  →";baseColor:"white";hoverColor:"#F3F2F4";textColor:Style.Theme.textPrimary;onClicked:appState.navigate("live") }
                    Text { width:parent.width;text:"Start or continue live monitoring\nto track your posture in real time.";color:"#B7B6C0";font.family:Style.Theme.fontFamily;font.pixelSize:11;lineHeight:1.3 }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 255
            spacing: 16
            AppCard {
                Layout.fillWidth: true; Layout.preferredWidth: 760; Layout.fillHeight: true
                Column {
                    anchors.fill:parent; anchors.margins:18; spacing:2
                    Row { width:parent.width
                        Column { width:parent.width-110; spacing:3
                            Text{text:"Posture trend";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:18;font.weight:Font.Bold}
                            Text{text:trendPeriod.currentIndex===0?"Your posture quality during the last 7 days":"Your posture quality during the last month";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:12}
                        }
                        AppSelect { id:trendPeriod;width:105; model:["Week","Month"]; currentIndex:0 }
                    }
                    LineChart { width:parent.width;height:175;values:trendPeriod.currentIndex===0?appState.weeklyQuality:root.monthStats.values;labels:trendPeriod.currentIndex===0?appState.weeklyLabels:root.monthStats.labels }
                }
            }
            AppCard {
                Layout.fillWidth: true; Layout.preferredWidth: 320; Layout.fillHeight:true
                cardColor:Style.Theme.forwardSoft
                Column { anchors.fill:parent;anchors.margins:18;spacing:9
                    Text{text:"Today’s focus";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:18;font.weight:Font.Bold}
                    Row { spacing:12
                        Rectangle{width:54;height:54;radius:14;color:Style.Theme.lilacSoft;Text{anchors.centerIn:parent;text:"◎";font.pixelSize:26;color:"#34275E"}}
                        Column{spacing:3;Text{text:appState.dashboardSummary.focus;font.family:Style.Theme.fontFamily;font.pixelSize:17;font.weight:Font.Bold;color:Style.Theme.textPrimary}Text{text:appState.dashboardSummary.focusMinutes+" min total";font.family:Style.Theme.fontFamily;font.pixelSize:13;font.weight:Font.DemiBold;color:Style.Theme.textPrimary}Text{text:"↓ 12% compared with yesterday";font.family:Style.Theme.fontFamily;font.pixelSize:11;color:"#4C9C28"}}
                    }
                    Text{width:parent.width;text:"You’re leaning forward less than yesterday. Keep it up!";wrapMode:Text.WordWrap;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:12}
                    Text{text:"View details  →";color:"#6D48DF";font.family:Style.Theme.fontFamily;font.pixelSize:12;font.weight:Font.DemiBold;MouseArea{anchors.fill:parent;cursorShape:Qt.PointingHandCursor;onClicked:appState.navigate("statistics")}}
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 175
            spacing: 16
            AppCard {
                Layout.fillWidth:true;Layout.preferredWidth:590;Layout.fillHeight:true
                Column{anchors.fill:parent;anchors.margins:18;spacing:8
                    Text{text:"Today’s posture";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:18;font.weight:Font.Bold}
                    Repeater { model: appState.postureDistribution
                        delegate: DistributionBar { width:parent.width; height:34; label:modelData.label; value:modelData.value; accent:Style.Theme.postureColor(modelData.key) }
                    }
                }
            }
            AppCard {
                Layout.fillWidth:true;Layout.preferredWidth:490;Layout.fillHeight:true
                Column{anchors.fill:parent;anchors.margins:18;spacing:7
                    Text{text:"Recent posture events";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:18;font.weight:Font.Bold}
                    Text{visible:appState.recentEvents.length===0;text:"Start monitoring to see your posture events.";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:12}
                    Repeater { model: Math.min(3,appState.recentEvents.length)
                        delegate: Row { property var ev: appState.recentEvents[index]; width:parent.width;height:27;spacing:10
                            Rectangle{width:10;height:10;radius:5;color:Style.Theme.postureColor(parent.ev.key);anchors.verticalCenter:parent.verticalCenter}
                            Text{text:parent.ev.time;color:"#657095";font.family:Style.Theme.fontFamily;font.pixelSize:11;width:48}
                            Text{text:parent.ev.label;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11;width:135}
                            Text{width:Math.max(0,parent.width-230);elide:Text.ElideRight;text:parent.ev.detail;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:11}
                        }
                    }
                    Text{text:"View session history  →";color:"#6D48DF";font.family:Style.Theme.fontFamily;font.pixelSize:11;font.weight:Font.DemiBold;MouseArea{anchors.fill:parent;cursorShape:Qt.PointingHandCursor;onClicked:appState.navigate("history")}}
                }
            }
        }
    }
}
