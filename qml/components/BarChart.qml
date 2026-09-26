import QtQuick
import "../theme" as Style

Item {
    id: root
    property var values: []
    property var labels: []
    property color barColor: Style.Theme.peach

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx=getContext("2d"); ctx.clearRect(0,0,width,height)
            var left=30,right=8,top=8,bottom=24,w=width-left-right,h=height-top-bottom
            var max=Math.max(4,Math.ceil(Math.max.apply(null,root.values)/4)*4)
            ctx.strokeStyle=Style.Theme.grid; ctx.fillStyle=Style.Theme.textSecondary; ctx.font="10px '"+Style.Theme.fontFamily+"'"
            for(var t=0;t<=max;t+=max/4){
                var y=top+h-h*t/max
                ctx.beginPath();ctx.moveTo(left,y);ctx.lineTo(left+w,y);ctx.stroke()
                ctx.textAlign="right";ctx.fillText(t,left-7,y+3)
            }
            var step=w/root.values.length
            for(var i=0;i<root.values.length;i++){
                var bw=Math.min(32,step*0.56),x=left+i*step+(step-bw)/2,bh=h*root.values[i]/max,yb=top+h-bh
                ctx.fillStyle=root.barColor
                if(ctx.roundRect){ctx.beginPath();ctx.roundRect(x,yb,bw,bh,4);ctx.fill()}else{ctx.fillRect(x,yb,bw,bh)}
                ctx.fillStyle="#69708D";ctx.textAlign="center";ctx.fillText(root.labels[i],x+bw/2,top+h+16)
            }
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }
    onValuesChanged: canvas.requestPaint()
    onLabelsChanged: canvas.requestPaint()
}
