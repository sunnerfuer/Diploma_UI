import QtQuick
import "../theme" as Style

Item {
    id: root
    property var values: []
    property var labels: []
    property color lineColor: Style.Theme.chartLine
    property bool showValueBubble: true
    property int hoveredIndex: -1

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            var left = 44, right = 30, top = 36, bottom = 30
            var w = width - left - right
            var h = height - top - bottom
            ctx.font = "11px '" + Style.Theme.fontFamily + "'"
            ctx.textAlign = "right"
            ctx.textBaseline = "middle"
            ctx.strokeStyle = Style.Theme.grid
            ctx.fillStyle = Style.Theme.textSecondary
            ctx.lineWidth = 1
            var ticks = [50,75,100]
            for (var i=0;i<ticks.length;i++) {
                var y = top + h - h * ticks[i] / 100
                ctx.beginPath(); ctx.moveTo(left, y); ctx.lineTo(left+w, y); ctx.stroke()
                ctx.fillText(ticks[i] + "%", left-8, y)
            }
            if (!root.values || root.values.length < 2) return
            var pts = []
            for (var j=0;j<root.values.length;j++) {
                var x = left + (w * j / (root.values.length-1))
                var py = top + h - h * root.values[j] / 100
                pts.push([x,py])
                ctx.textAlign = "center"
                ctx.fillStyle = "#69708D"
                ctx.fillText(root.labels[j], x, top+h+18)
            }
            // soft area fill
            var grad = ctx.createLinearGradient(0,top,0,top+h)
            grad.addColorStop(0,"rgba(207,234,122,0.26)")
            grad.addColorStop(1,"rgba(207,234,122,0.02)")
            ctx.beginPath(); ctx.moveTo(pts[0][0], top+h)
            for (var k=0;k<pts.length;k++) ctx.lineTo(pts[k][0], pts[k][1])
            ctx.lineTo(pts[pts.length-1][0], top+h); ctx.closePath()
            ctx.fillStyle = grad; ctx.fill()
            // line
            ctx.beginPath(); ctx.moveTo(pts[0][0],pts[0][1])
            for (var n=1;n<pts.length;n++) ctx.lineTo(pts[n][0],pts[n][1])
            ctx.strokeStyle = root.lineColor; ctx.lineWidth = 2.4; ctx.stroke()
            for (var p=0;p<pts.length;p++) {
                if (p !== root.hoveredIndex && p !== pts.length-1) continue
                ctx.beginPath(); ctx.arc(pts[p][0],pts[p][1],4.8,0,Math.PI*2)
                ctx.fillStyle = root.lineColor; ctx.fill()
                ctx.strokeStyle = "white"; ctx.lineWidth=1.5; ctx.stroke()
            }
            if (root.showValueBubble) {
                var selected = root.hoveredIndex >= 0 ? root.hoveredIndex : pts.length-1
                var last = pts[selected]
                ctx.fillStyle = "#EAF7CF"
                ctx.beginPath();
                if (ctx.roundRect) ctx.roundRect(last[0]-24,last[1]-35,48,25,8)
                else ctx.rect(last[0]-24,last[1]-35,48,25)
                ctx.fill()
                ctx.fillStyle = Style.Theme.textPrimary; ctx.font="bold 12px '"+Style.Theme.fontFamily+"'"; ctx.textAlign="center"
                ctx.fillText(root.values[selected] + "%", last[0], last[1]-22)
            }
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }
    onValuesChanged: canvas.requestPaint()
    onLabelsChanged: canvas.requestPaint()
    onHoveredIndexChanged: canvas.requestPaint()
    MouseArea {
        anchors.fill:parent
        hoverEnabled:true
        acceptedButtons:Qt.NoButton
        onPositionChanged: mouse => { root.hoveredIndex=Math.max(0,Math.min(root.values.length-1,Math.round((mouse.x-44)/(width-74)*(root.values.length-1)))) }
        onExited:root.hoveredIndex=-1
    }
}
