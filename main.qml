import QtQuick 2.7
import QtQuick.Controls 2.12
import QtQuick.Window 2.0
import QtMultimedia 5.12
import QtWebView 1.1
import Qt.labs.settings 1.1
import unik.UnikQProcess 1.0

ApplicationWindow{
    id: app
    visible: true
    visibility: "Maximized"
    color: 'transparent'
    title: 'Twicht Chat Speech'
    property int fs: width*0.02
    property string userAdmin: 'RicardoMartinPizarro'
    property bool voiceEnabled: true
    property bool ringEnabled: false
    property bool sendEmail: true
    property bool editable: false
    property bool toWriteInTawk: false
    property var aVoices: [
        'es-ES_EnriqueVoice',
        'es-ES_EnriqueV3Voice',
        'es-ES_LauraVoice',
        'es-ES_LauraV3Voice',
        'es-LA_SofiaVoice',
        'es-LA_SofiaV3Voice',
        'es-US_SofiaVoice',
        'es-US_SofiaV3Voice',
        'en-GB_CharlotteV3Voice',
        'en-GB_KateVoice',
        'en-GB_KateV3Voice',
        'en-GB_JamesV3Voice',
        'en-US_AllisonVoice',
        'en-US_AllisonV3Voice',
        'en-US_EmilyV3Voice',
        'en-US_OliviaV3Voice',
        'en-US_LisaVoice',
        'en-US_LisaV3Voice',
        'en-US_HenryV3Voice',
        'en-US_KevinV3Voice',
        'en-US_MichaelVoice',
        'en-US_MichaelV3Voice']
    onClosing: {
        close.accepted = true
        Qt.quit()
    }
    onVisibilityChanged: {
        if(app.visibility===ApplicationWindow.Maximized){
            app.editable=!app.editable
            showMode(app.editable)
        }
    }
    onVoiceEnabledChanged: {
        if(!voiceEnabled){
            mp.stop()
            playlist.clear()
        }
    }
    onActiveChanged: {
        //        if(active){
        //            app.editable=true
        //            showMode(app.editable)
        //        }
    }

    Audio {
        id: mpRing
        source: 'file:/home/ns/nsp/uda/twitch-chat/sounds/ring_1.mp3';
        autoLoad: true
        autoPlay: true
    }
    Audio {
        id: mp2
        //source: 'file:/home/ns/nsp/uda/twitch-chat/sounds/ring_1.mp3';
        //autoLoad: true
        //autoPlay: true
        onPlaybackStateChanged:{
            if(mp2.playbackState===Audio.StoppedState){
                playlist2.removeItem(0)
            }
        }
        playlist: Playlist {
            id: playlist2
            onItemCountChanged:{
                //xMsgList.actualizar(playlist)
            }
        }
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
    Settings{
        id: apps
        property string uHtml: ''
    }
    Item{
        id: xAppWV
        anchors.fill: parent
        opacity: app.editable?1.0:0.65
        WebView{
            id: wv
            width: parent.width
            height: parent.height//*0.5
            x:app.width+1280
            //            y: 100
            url:"https://streamlabs.com/widgets/chat-box/v1/15602D8555920F741CDF"
            visible:false
            onLoadProgressChanged:{
                if(loadProgress===100){
                    tCheck.start()
                }
            }
        }
    }
    Item{
        id: xApp
        anchors.fill: parent
        //opacity: app.editable?1.0:0.65
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
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    Qt.quit()
                    app.editable=false
                    console.log('Desactivando...')
                    showMode(app.editable)
                }
                Rectangle{
                    anchors.fill: parent
                    color: '#ff8833'
                }
            }
        }

        Row{
            id: mainRow
            width: parent.width
            height: parent.height
            XMsgList{
                id: xMsgList
                width: mainRow.width-xUserList.width
                border.width: app.editable?2:0
            }
            XUsersList{
                id: xUserList
                width: mainRow.width*0.25
                border.width: app.editable?2:0
            }
        }
    }
    Item{
        id: xAlarmVisual
        visible: false
        width: Screen.width
        height: Screen.desktopAvailableHeight
        MouseArea{
            anchors.fill: parent
            onClicked: {
                //app.flags=Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.WindowTransparentForInput
                for(var i=0;i<xAlarmVisual.children.length;i++){
                    xAlarmVisual.children[i].destroy()
                }
                xAlarmVisual.visible=false
            }
        }
        function addAlarmVisual(t){
            let comp = Qt.createComponent("XAlarmVisual.qml")
            let obj=comp.createObject(xAlarmVisual, {text: t})
            xAlarmVisual.visible=true
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
                        if(isVM(nMsg)&&nMsg!==''&&nMsg!==app.uMsg){
                            //let nDate=new Date(Date.now())
                            //let msDate=nDate.getTime()
                            app.uMsg=nMsg//uMsgs[uMsgs.length-1]
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
                            let msg2=msg
                            if(app.toWriteInTawk)writeInTawk(uMsgs[uMsgs.length-1])
                            msg=msg.replace(/ /g, '%20').replace(/_/g, ' ')
                            //console.log('MSG: '+msg)
                            //playlist.addItem('https://text-to-speech-demo.ng.bluemix.net/api/v3/synthesize?text='+msg+'&voice=es-ES_EnriqueVoice&download=true&accept=audio%2Fmp3')
                            if(isCommand(mm0[1])){
                                //let nDate=new Date(Date.now())
                                //app.uMsg=' '+nMsg+' ms='+nDate.getTime()
                                runCommand(mm0[0], mm0[1])
                            }else{
                                let indexVoice=xUserList.getIndexVoice(mm0[0])
                                if(indexVoice<0)indexVoice=0
                                if(app.voiceEnabled && !app.ringEnabled){
                                    playlist.addItem('https://text-to-speech-demo.ng.bluemix.net/api/v3/synthesize?text='+msg+'&voice='+app.aVoices[indexVoice]+'&download=true&accept=audio%2Fmp3')
                                    mp.play()
                                }else{
                                    if(app.ringEnabled)mpRing.play()
                                }
                                sendEMail('nextsigner@gmail.com', 'qtpizarro@gmail.com', 'Mensaje de '+mm0[0], msg.replace(/%20/g, ' '))
                                if(xUserList.alarmaVisual){
                                    //console.log('Ejecutando alarma visual...')
                                    xAlarmVisual.addAlarmVisual(msg2)
                                    app.editable=true
                                    showMode(app.editable)
                                    //Qt.quit()
                                }else{
                                    console.log('NO Ejecutando alarma visual...')
                                }
                                let mps=(''+mp.source).replace('file://', '')
                                info.text=mps+' '+unik.fileExist(mps)
                            }
                        }else{
//                            if(isCommand(nMsg)){
//                                let nDate=new Date(Date.now())
//                                nMsg+=' ms='+nDate.getTime()
//                                //uMsgs[uMsgs.length-1]=nMsg
//                                speakInMp2('Se repite '+nMsg)
//                            }else{
//                                //speakInMp2('Se repite 2 '+nMsg)
//                            }

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
    Timer{
        id: tM
        running: false
        repeat: false
        interval: 3000
        onTriggered: {
            let code=''
            code+='import QtQuick 2.0\n'
            code+='Rectangle{\n'
            //code+=' z: xMsgList.z-1\n'
            code+=' color: "blue"\n'
            code+=' anchors.fill: parent\n'
            code+=' MouseArea{\n'
            code+='     anchors.fill: parent\n'
            code+='    onClicked: { \n'
            code+='         console.log("Ejecutando...")\n'
            code+='         parent.color="red"\n'
            code+='         app.showMode(false)\n'
            code+='     }\n'
            code+=' }\n'
            code+=' Component.onCompleted: {\n'
            //code+='     mainRow.z=z+1\n'
            code+=' }\n'
            code+='}\n'
            let comp=Qt.createQmlObject(code, xApp, 'code')
        }
    }
    Timer{
        id: tCheckHttp
        running: true
        repeat: true
        interval: 3000
        onTriggered: getHttp()
    }


    Shortcut{
        sequence: 'Esc'
        onActivated: {
            for(var i=0;i<xAlarmVisual.children.length;i++){
                xAlarmVisual.children[i].destroy()
            }
            xAlarmVisual.visible=false
        }
    }
    UnikQProcess{
        id: uqp
    }
    Component.onCompleted: {
        let sargs=Qt.application.arguments.toString()
        if(sargs.indexOf('writetawk')>=0)app.toWriteInTawk=true

        speakInMp2('Texto del chat a voz iniciado.')
    }
    function speakInMp2(msg){
        msg=msg.replace(/ /g, '%20').replace(/_/g, ' ')
        playlist2.addItem('https://text-to-speech-demo.ng.bluemix.net/api/v3/synthesize?text='+msg+'&voice='+app.aVoices[0]+'&download=true&accept=audio%2Fmp3')
        mp2.play()
    }
    function isCommand(msg){
        let ret=false
        if(msg.indexOf('!')===0)ret=true
        return ret
    }
    function runCommand(user, msg){
        console.log('Run command: ['+msg+']')
        //mp2.play()
        if(user.indexOf(app.userAdmin)>=0){
            console.log('Run command as admin: ['+user+']')
            if(msg.indexOf('!ve')===0){
                if(app.voiceEnabled){
                    speakInMp2('Voces desactivadas.')
                }else{
                    speakInMp2('Voces activadas.')
                    app.ringEnabled=false
                }
                app.voiceEnabled=!app.voiceEnabled
            }
            if(msg.indexOf('!re')===0){
                if(app.ringEnabled){
                    speakInMp2('Se desactiva el timbre.')
                }else{
                    speakInMp2('Se activa el timbre.')
                }
                app.ringEnabled=!app.ringEnabled
            }

        }else{
            console.log('Run command as user: ['+user+']')
            if(msg.indexOf('!ring')===0 || msg.indexOf('!turno')===0){
                speakInMp2('Llamando desde el chat.')
                mpRing.play()
            }
        }
    }
    function getHttp(){
        var req = new XMLHttpRequest();
        req.open('GET', 'http://168.181.186.73:8081/files/ping.html', false);
        req.send(null);
        if (req.status == 200){
            if(req.responseText.indexOf('dato')>=0){
                //app.color='yellow'
            }
        }else{
            //app.color='red'
            unik.speak('Internet')
            tCheckHttp.interval=6000
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
    function showMode(b){
        if(b){
            app.flags=Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint// | Qt.WindowTransparentForInput
            //app.flags=Qt.Window | Qt.WindowStaysOnTopHint// | Qt.WindowTransparentForInput
            //app.flags=Qt.Window | Qt.WindowStaysOnTopHint
            //app.raise()
            //app.modality=Qt.ApplicationModal
            //app.active=true
        }else{
            app.flags=Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.WindowTransparentForInput
            //app.flags=Qt.Window | Qt.WindowStaysOnTopHint | Qt.WindowTransparentForInput
        }
    }
    function writeInTawk(text){
        unik.ejecutarLineaDeComandoAparte('sh /home/ns/nsp/uda/tawk-chat/writemsg.sh "'+text+'"')
    }
    function getMailData(from, to, subject, message){
        let mail='To: '+to+'
From: '+from+'
Subject: '+subject+'
'+message+'
'
        return mail
    }
    function sendEMail(from, to, subject, message){
        let emailData=getMailData(from, to, subject, message)
        let d=new Date(Date.now())
        let file='/tmp/'+d.getTime()+'.txt'
        unik.setFile(file, emailData)
        let cmdLine='ssmtp '+to+' < '+file
        //uqp.run(cmdLine)
        //unik.setFile('/home/ns/cmd.txt', cmdLine)
        //unik.ejecutarLineaDeComandoAparte(cmdLine)
    }
}
