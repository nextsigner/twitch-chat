import QtQuick 2.7
import QtQuick.Controls 2.12
import QtMultimedia 5.12
import QtWebView 1.1
import Qt.labs.settings 1.1
ApplicationWindow{
    id: app
    visible: true
    visibility: "Maximized"
    color: 'transparent'
    title: 'Twicht Chat Speech'
    property int fs: width*0.02
    onClosing: {
        close.accepted = true
        Qt.quit()
    }
    Audio {
        id: mp;
        onPlaybackStateChanged:{
            if(mp.playbackState===Audio.StoppedState){
                playlist.removeItem(0)
            }
        }
        playlist: Playlist {
            id: playlist
            onItemCountChanged:{
                xMsgList.actualizar(playlist)
            }
        }
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
            width: parent.width
            height: parent.height//*0.5
            //            x:50
            //            y: 100
            url:"https://streamlabs.com/widgets/chat-box/v1/15602D8555920F741CDF"
            //visible:false
            onLoadProgressChanged:{
                if(loadProgress===100){
                    tCheck.start()
                }
            }
        }
        Rectangle{
            id: xLed
            width: 100
            height: width
            border.width: 4
            border.color: '#ff8833'
            radius: 10
            property bool toogle: false
            color: toogle?'red':'green'
            visible: false
            Text {
                id: info
                text: 'nada'
                font.pixelSize: 24
                width: xApp.width-20
                wrapMode: Text.WordWrap
                anchors.left: parent.left
                anchors.leftMargin: 20
            }
        }
        Row{
            id: mainRow
            width: parent.width
            height: parent.height
            XMsgList{
                id: xMsgList
                width: mainRow.width*0.5
            }
            XUsersList{
                id: xUserList
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
                    //if(app.uMsg!==uMsgs[uMsgs.length-1]){
                    //mp.play()
                    //}
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
                        let nMsg=uMsgs[uMsgs.length-1]
                        if(isVM(nMsg)&&uMsgs[uMsgs.length-1]!==''&&uMsgs[uMsgs.length-1]!==app.uMsg){
                            app.uMsg=uMsgs[uMsgs.length-1]
                            xLed.toogle=!xLed.toogle
                            xLed.z=xLed.z+wv.z+1000
                            //mp.source='https://text-to-speech-demo.ng.bluemix.net/api/v3/synthesize?text=ricardo%20%20martin%20dice%20probando%20audio&voice=es-ES_EnriqueVoice&download=true&accept=audio%2Fmp3'
                            let mm0=app.uMsg.trim().split('\t')
                            console.log('mm0['+mm0[0]+']')
                            xUserList.addUser(mm0[0])
                            if(!xUserList.userIsEnabled(mm0[0])){
                                console.log('User disabled: '+mm0[0])
                                return
                            }
                            let msg=app.uMsg.replace(mm0[0], mm0[0]+' dice ')
                            msg=msg.replace(/ /g, '%20').replace(/_/g, ' ')
                            //console.log('MSG: '+msg)
                            playlist.addItem('https://text-to-speech-demo.ng.bluemix.net/api/v3/synthesize?text='+msg+'&voice=es-ES_EnriqueVoice&download=true&accept=audio%2Fmp3')
                            mp.play()
                            let mps=(''+mp.source).replace('file://', '')
                            info.text=mps+' '+unik.fileExist(mps)
                        }
                        //console.log('Html2: '+uMsgs.toString())
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
    function isVM(msg){
        if(msg.indexOf('http:/')>=0||msg.indexOf('https:/')>=0){
            return false
        }
        //Nightbot
        if(msg.indexOf('Nightbot')>=0){
            return false
        }
        return true
    }
}
