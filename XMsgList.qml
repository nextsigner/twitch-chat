import QtQuick 2.0

Rectangle {
    id: r
    width: parent.width
    height: parent.height
    border.width: 2
    border.color: 'red'
    color: 'transparent'
//    MouseArea{
//        anchors.fill: parent
//        onClicked: Qt.quit()//app.flags=Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.WindowTransparentForInput
//    }
    ListView{
        id: lv
        anchors.fill: r
        model: lm
        delegate: del
    }
    ListModel{
        id: lm
        function addItem(url){
            return {
                u: url
            }
        }
    }
    Component{
        id: del
        Rectangle{
            id: xMsg
            width: r.width-app.fs
            height: txtMsg.contentHeight+app.fs
            border.width: 3
            border.color: 'blue'
            color: 'black'
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtMsg
                text: 'Msg: '+u
                font.pixelSize: app.fs
                width: parent.width-app.fs
                wrapMode: Text.WordWrap
                anchors.centerIn: parent
                color: 'white'
            }
            MouseArea{
                anchors.fill: parent
                onClicked: unik.speak('Click')
            }
            Component.onCompleted: {
                //mp.source='https://text-to-speech-demo.ng.bluemix.net/api/v3/synthesize?text=ricardo%20%20martin%20dice%20probando%20audio&voice=es-ES_EnriqueVoice&download=true&accept=audio%2Fmp3'
                let m0=u.split('text=')
                if(m0.length>=1){
                    let m1=(''+m0[1]).split('&')
                    txtMsg.text=(''+m1[0]).replace(/%20/g, ' ').replace(/%09/g, ' ')
                }
                lv.currentIndex=index
            }
        }
    }
    function actualizar(pl){
        lm.clear()
        for(var i=0;i<pl.itemCount;i++){
            lm.append(lm.addItem(pl.itemSource(i).toString()))
        }
    }
    Timer{
        id: tM
        running: true
        repeat: false
        interval: 3000
        onTriggered: {
            let code=''
            code+='import QtQuick 2.0\n'
            code+='Rectangle{\n'
            //code+=' z: lv.z-1\n'
            code+=' color: "transparent"\n'
            code+=' anchors.fill: parent\n'
            code+=' MouseArea{\n'
            code+='     anchors.fill: parent\n'
            code+='    onClicked: { \n'
            code+='         console.log("Ejecutando...")\n'
            //code+='         parent.color="red"\n'
            code+='         app.showMode(false)\n'
            code+='     }\n'
            code+=' }\n'
            code+=' Component.onCompleted: {\n'
            //code+='     mainRow.z=z+1\n'
            code+=' }\n'
            code+='}\n'
            let comp=Qt.createQmlObject(code, r, 'code')
        }
    }
}
