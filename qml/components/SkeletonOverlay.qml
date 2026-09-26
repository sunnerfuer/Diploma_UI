import QtQuick
import "../theme" as Style

Canvas {
    id: root
    property string postureKey: "good"
    property bool mirrored: false
    property real imageWidth: 600
    property real imageHeight: 330
    opacity: 0.8
    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        var scale = Math.max(width / imageWidth, height / imageHeight)
        var w = imageWidth * scale, h = imageHeight * scale
        ctx.translate((width - w) / 2, (height - h) / 2)
        if (mirrored) { ctx.translate(w, 0); ctx.scale(-1, 1) }
        var pts = postureKey === "forward"
            ? [[.50,.44],[.39,.66],[.50,.67],[.61,.66],[.31,.95],[.69,.95],[.50,.97]]
            : postureKey === "left"
              ? [[.45,.34],[.35,.60],[.47,.64],[.59,.68],[.28,.95],[.65,.98],[.50,.98]]
              : [[.50,.35],[.36,.64],[.50,.64],[.64,.64],[.28,.96],[.72,.96],[.50,.98]]
        ctx.strokeStyle = "rgba(255,255,255,.8)"
        ctx.lineWidth = 2
        ctx.lineCap = "round"
        var lines = [[0,2],[1,2],[2,3],[1,4],[3,5],[2,6]]
        for (var i=0; i<lines.length; i++) {
            var a=pts[lines[i][0]], b=pts[lines[i][1]]
            ctx.beginPath(); ctx.moveTo(a[0]*w,a[1]*h); ctx.lineTo(b[0]*w,b[1]*h); ctx.stroke()
        }
        for (var j=0;j<pts.length;j++) {
            ctx.beginPath();ctx.arc(pts[j][0]*w,pts[j][1]*h,j===0?6:5,0,Math.PI*2)
            ctx.fillStyle=Style.Theme.postureColor(postureKey);ctx.fill();ctx.stroke()
        }
    }
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onPostureKeyChanged: requestPaint()
    onMirroredChanged: requestPaint()
    onVisibleChanged: requestPaint()
}
