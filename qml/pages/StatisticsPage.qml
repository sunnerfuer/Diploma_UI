import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Style
import "../components"

PageScaffold {
    id: root
    readonly property int periodIndex: ["day","week","month"].indexOf(appState.statisticsPeriod)
    readonly property var stats: appState.statisticsSummary
    clip: true
    contentWidth: width
    contentHeight: Math.max(height, content.implicitHeight + Style.Theme.pagePadding * 2)

    ColumnLayout {
        id: content
        x: Style.Theme.pagePadding
        y: 14
        width: root.width - Style.Theme.pagePadding * 2
        spacing: 16

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            Column {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; spacing:3
                Text{text:"Statistics";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:Style.Theme.pageTitle;font.weight:Font.Bold}
                Text{text:"See how your posture changes over time.";color:"#657095";font.family:Style.Theme.fontFamily;font.pixelSize:14}
            }
            Row {
                anchors.right:parent.right;anchors.verticalCenter:parent.verticalCenter;spacing:16
                SegmentedControl { objectName:"statisticsPeriodControl";width:260; currentIndex:root.periodIndex; options:["Day","Week","Month"]; onSelected: index => appState.setStatisticsPeriod(["day","week","month"][index]) }
                Rectangle { width:1;height:34;color:Style.Theme.border;anchors.verticalCenter:parent.verticalCenter }
                Text{text:root.stats.dateRange;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:12;anchors.verticalCenter:parent.verticalCenter}
            }
        }

        RowLayout {
            Layout.fillWidth:true;Layout.preferredHeight:170;spacing:16
            MetricCard{Layout.fillWidth:true;Layout.fillHeight:true;title:"POSTURE QUALITY";value:root.stats.quality+"%";footnote:root.stats.qualityChange;accent:Style.Theme.lilac;softColor:Style.Theme.lilacSoft;iconText:"☺"}
            AppCard {
                Layout.fillWidth:true;Layout.fillHeight:true;cardColor:Style.Theme.goodSoft;strokeColor:"#DDEDC2"
                Row{anchors.fill:parent;anchors.margins:20;spacing:12
                    Column{width:parent.width-112;spacing:5
                        Text{text:"GOOD POSTURE";color:"#455261";font.family:Style.Theme.fontFamily;font.pixelSize:11;font.weight:Font.Bold;font.letterSpacing:1}
                        Text{text:appState.statisticsSummary.goodTime;color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:38;font.weight:Font.Bold}
                        Text{text:appState.statisticsSummary.goodPercent+"% of monitored time";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:14;font.weight:Font.DemiBold}
                    }
                    CircularProgress{width:90;height:90;value:root.stats.goodPercent/100;accent:Style.Theme.chartLine;track:Style.Theme.goodSoft;strokeWidth:10;anchors.verticalCenter:parent.verticalCenter;Text{anchors.centerIn:parent;text:root.stats.goodPercent+"%";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:18;font.weight:Font.Bold}}
                }
            }
            MetricCard{Layout.fillWidth:true;Layout.fillHeight:true;title:"CORRECTIONS";value:root.stats.corrections;footnote:root.stats.correctionsChange;accent:Style.Theme.peach;softColor:Style.Theme.peachSoft;iconText:"✎"}
        }

        RowLayout {
            Layout.fillWidth:true;Layout.preferredHeight:335;spacing:16
            AppCard {
                Layout.fillWidth:true;Layout.preferredWidth:760;Layout.fillHeight:true
                Column{anchors.fill:parent;anchors.margins:18;spacing:3
                    Row{width:parent.width
                        Column{width:parent.width;spacing:3
                            Text{text:"Posture quality over time";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:19;font.weight:Font.Bold}
                            Text{text:"Percentage of monitored time spent in a neutral posture";color:"#667092";font.family:Style.Theme.fontFamily;font.pixelSize:12}
                        }
                    }
                    LineChart{width:parent.width;height:250;values:root.stats.values;labels:root.stats.labels}
                }
            }
            AppCard {
                Layout.fillWidth:true;Layout.preferredWidth:330;Layout.fillHeight:true
                Column{anchors.fill:parent;anchors.margins:18;spacing:11
                    Text{text:"Posture distribution";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:19;font.weight:Font.Bold}
                    Text{text:"Average posture breakdown "+root.stats.periodLabel;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:12}
                    Item{height:3;width:1}
                    Repeater{model:root.stats.distribution;delegate:DistributionBar{width:parent.width;height:62;label:modelData.label;value:modelData.value;accent:Style.Theme.postureColor(modelData.key)}}
                }
            }
        }

        RowLayout {
            Layout.fillWidth:true;Layout.preferredHeight:205;spacing:16
            AppCard {
                Layout.fillWidth:true;Layout.preferredWidth:310;Layout.fillHeight:true;cardColor:Style.Theme.forwardSoft;strokeColor:"#F2CDBE"
                Column{anchors.fill:parent;anchors.margins:20;spacing:8
                    Text{text:"Most common issue";color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:17;font.weight:Font.Bold}
                    Text{width:parent.width;text:root.stats.commonIssue;wrapMode:Text.WordWrap;color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:25;font.weight:Font.Bold}
                    Text{text:root.stats.commonIssueTime+" "+root.stats.periodLabel;color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:15;font.weight:Font.DemiBold}
                    Text{text:root.stats.issueChange;color:Style.Theme.positiveText;font.family:Style.Theme.fontFamily;font.pixelSize:11;font.weight:Font.DemiBold}
                }
            }
            AppCard {
                Layout.fillWidth:true;Layout.preferredWidth:440;Layout.fillHeight:true
                Column{anchors.fill:parent;anchors.margins:16;spacing:2
                    Row{width:parent.width
                        Column{width:parent.width;Text{text:root.periodIndex===0?"Corrections by hour":(root.periodIndex===2?"Corrections by week":"Corrections by day");color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:17;font.weight:Font.Bold}Text{text:"Total "+root.stats.corrections+" corrections";color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:12}}
                    }
                    BarChart{width:parent.width;height:140;values:root.stats.bars;labels:root.stats.labels}
                }
            }
            AppCard {
                Layout.fillWidth:true;Layout.preferredWidth:300;Layout.fillHeight:true;cardColor:Style.Theme.lilacSoft;strokeColor:"#DED2F7"
                Column{anchors.fill:parent;anchors.margins:20;spacing:10
                    Text{text:"Consistency";color:"#403273";font.family:Style.Theme.fontFamily;font.pixelSize:17;font.weight:Font.Bold}
                    Row{spacing:8;Text{text:root.stats.consistency;color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:34;font.weight:Font.Bold}Text{text:root.stats.unit;color:Style.Theme.textPrimary;font.family:Style.Theme.fontFamily;font.pixelSize:18;font.weight:Font.DemiBold;anchors.bottom:parent.bottom; anchors.bottomMargin:5}}
                    Text{width:parent.width;text:root.stats.consistencyText;wrapMode:Text.WordWrap;color:Style.Theme.textSecondary;font.family:Style.Theme.fontFamily;font.pixelSize:13;lineHeight:1.25}
                }
            }
        }
    }
}
