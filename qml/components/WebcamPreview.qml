import QtQuick
import QtQuick.Effects
import "../theme" as Style

Rectangle {
    id: root
    property string postureKey: "good"
    property bool skeletonVisible: true
    property bool live: true
    property bool paused: false
    property bool framingGuide: false
    property bool mirrored: false
    property url frameSource: ""
    property string cameraLabel: "Integrated Webcam"
    readonly property bool demoSource: frameSource.toString().length === 0
    signal skeletonToggled(bool checked)
    radius: Style.Theme.cardRadius
    color: Style.Theme.surfaceSubtle
    clip: true

    Item {
        anchors.fill: parent
        layer.enabled: GraphicsInfo.api !== GraphicsInfo.Software
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mask
        }
        Image {
            anchors.fill: parent
            source: root.demoSource ? "../../assets/camera_" + root.postureKey + ".jpg" : root.frameSource
            cache: root.demoSource
            fillMode: Image.PreserveAspectCrop
            mirror: root.mirrored
            smooth: true
        }
        SkeletonOverlay {
            anchors.fill: parent
            // Backend frames need their own normalized pose overlay; never paint demo points on them.
            visible: root.skeletonVisible && !root.framingGuide && root.demoSource
            postureKey: root.postureKey
            mirrored: root.mirrored
        }
    }
    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false
        Rectangle { anchors.fill: parent; radius: root.radius; color: "white" }
    }

    Canvas {
        anchors.fill: parent
        visible: root.framingGuide
        onPaint: {
            var ctx=getContext("2d");ctx.clearRect(0,0,width,height)
            ctx.strokeStyle=Style.Theme.lilac;ctx.lineWidth=3;ctx.lineCap="round"
            var x=width*.15,y=height*.15,w=width*.70,h=height*.72,l=28
            function seg(x1,y1,x2,y2){ctx.beginPath();ctx.moveTo(x1,y1);ctx.lineTo(x2,y2);ctx.stroke()}
            seg(x,y,x+l,y);seg(x,y,x,y+l);seg(x+w,y,x+w-l,y);seg(x+w,y,x+w,y+l)
            seg(x,y+h,x+l,y+h);seg(x,y+h,x,y+h-l);seg(x+w,y+h,x+w-l,y+h);seg(x+w,y+h,x+w,y+h-l)
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }

    Rectangle {
        x:12;y:12;width:root.paused?94:88;height:32;radius:10
        color:Style.Theme.overlay
        Row {
            anchors.centerIn:parent;spacing:7
            Rectangle{width:8;height:8;radius:4;color:root.live?Style.Theme.lime:Style.Theme.lilac;anchors.verticalCenter:parent.verticalCenter}
            Text{text:root.paused?"PAUSED":(root.live?"LIVE":"PREVIEW");color:"white";font.family:Style.Theme.fontFamily;font.pixelSize:11;font.weight:Font.Bold}
        }
    }
    Rectangle {
        visible:!root.framingGuide
        anchors.right:parent.right;anchors.top:parent.top;anchors.margins:12
        width:120;height:32;radius:10;color:Style.Theme.overlay
        Row {
            anchors.centerIn:parent;spacing:8
            Text{text:"Skeleton";color:"white";font.family:Style.Theme.fontFamily;font.pixelSize:11}
            ToggleSwitch{width:40;height:28;scale:.8;checked:root.skeletonVisible;onToggled:checked => root.skeletonToggled(checked)}
        }
    }
    Rectangle {
        anchors.left:parent.left;anchors.right:parent.right;anchors.bottom:parent.bottom
        height:34;color:Style.Theme.overlay
        Text{anchors.left:parent.left;anchors.leftMargin:14;anchors.verticalCenter:parent.verticalCenter;text:root.cameraLabel;color:"white";font.family:Style.Theme.fontFamily;font.pixelSize:11}
        Text{anchors.right:parent.right;anchors.rightMargin:14;anchors.verticalCenter:parent.verticalCenter;text:root.demoSource?"DEMO":"CAMERA";color:"white";font.family:Style.Theme.fontFamily;font.pixelSize:10}
    }
}
