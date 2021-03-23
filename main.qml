import QtQuick 2.7
import QtQuick.Controls 2.12
import QtMultimedia 5.12
import QtWebView 1.1
import Qt.labs.settings 1.1
ApplicationWindow{
    id: app
    visible: true
    visibility: "Maximized"
    MediaPlayer{
        id: mp
        source: './sounds/beep.wav'
        autoLoad: true
        autoPlay: true
    }
    Item{
        id: xApp
        anchors.fill: parent
        Settings{
            id: apps
            property string uHtml: ''
        }
        WebView{
            id: wv
            anchors.fill: parent
            url:"https://streamlabs.com/widgets/chat-box/v1/15602D8555920F741CDF"
            onLoadProgressChanged:{
                if(loadProgress===100){
                    tCheck.start()
                }
            }
        }
    }
    property string uMsg: 'null'
    Timer{
        id: tCheck
        running: false
        repeat: true
        interval: 100
        onTriggered: {
            running=false
            wv.runJavaScript('function doc(){var d=document.body.innerHTML; return d;};doc();', function(html){
                //console.log('Doc: '+html)
                if(html&&html!==apps.uHtml){
                    //unik.speak('yes')
                    wv.runJavaScript('function doc(){var d=document.body.innerText; return d;};doc();', function(html2){
                        //console.log('Html2: '+html2)
                        let m0=html2.split('\n')
                        let uMsgs=[]
                        let uindex=0
                        if(m0.length>1){
                            for(var i=0;i<m0.length;i++){
                                if(m0[i]===app.uMsg){
                                    uindex=i
                                }
                            }
                            for(i=uindex+1;i<m0.length;i++){
                                uMsgs.push(m0[i])
                            }
                        }else{
                            uMsgs.push(m0[0])
                        }
                        if(app.uMsg!==uMsgs[uMsgs.length-1]){
                            mp.play()
                        }
                        app.uMsg=uMsgs[uMsgs.length-1]
                        console.log('Html2: '+uMsgs.toString())
                        apps.uHtml=html
                        running=true
                        return
                    });
                }else{
                    //unik.speak('NO')
                    apps.uHtml=''
                    running=true
                    return
                }
                apps.uHtml=html
                running=true
            });
        }
    }
}
