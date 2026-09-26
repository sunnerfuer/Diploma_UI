import QtQuick
import "../theme" as Style

Item {
    id: root
    property real value: 0.75
    property color accent: Style.Theme.lilac
    property color track: "#EDE7FA"
    property real strokeWidth: 9
    implicitWidth: 112
    implicitHeight: 112

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx=getContext("2d");ctx.clearRect(0,0,width,height)
            var r=Math.min(width,height)/2-root.strokeWidth
            var cx=width/2,cy=height/2
            ctx.lineWidth=root.strokeWidth;ctx.lineCap="round"
            ctx.beginPath();ctx.strokeStyle=root.track;ctx.arc(cx,cy,r,-Math.PI/2,Math.PI*1.5);ctx.stroke()
            ctx.beginPath();ctx.strokeStyle=root.accent;ctx.arc(cx,cy,r,-Math.PI/2,-Math.PI/2+Math.PI*2*Math.max(0,Math.min(1,root.value)));ctx.stroke()
        }
        onWidthChanged: requestPaint(); onHeightChanged: requestPaint()
    }
    onValueChanged: canvas.requestPaint()
}
