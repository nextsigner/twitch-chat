import QtQuick 2.7
import QtQuick.Controls 2.12
import Qt.labs.settings 1.1

Rectangle {
    id: r
    width: parent.width*0.5
    height: parent.height
    border.width: 2
    border.color: 'red'
    color: 'transparent'
    property alias listModel: lm
    state: 'show'
    states: [
        State {
            name: "show"
            PropertyChanges {
                target: r
                width: r.parent.width*0.25
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                width: 1
            }
        }
    ]
    Behavior on width{NumberAnimation{duration: 250}}
    ListView{
        id: lv
        width: r.parent.width*0.25
        height: r.parent.height
        model: lm
        delegate: del
    }
    ListModel{
        id: lm
        function addItem(user){
            return {
                u: user,
                e: true
            }
        }
    }
    Component{
        id: del
        Rectangle{
            id: xUser
            width: u!=='ricardo__martin'?lv.width-app.fs:lv.width
            height: u!=='ricardo__martin'?txtUser.contentHeight+app.fs:bot1.height
            border.width: xUserSettings.enabled?4:1
            border.color: xUserSettings.enabled?'red':'blue'
            color: 'black'
            anchors.horizontalCenter: parent.horizontalCenter
            Settings{
                id: xUserSettings
                fileName: '../'+u+'.cfg'
                property bool enabled: true
                onEnabledChanged: e=enabled
            }
            Text {
                id: txtUser
                text: '<b>'+u+'</b>'
                font.pixelSize: xUserSettings.enabled?app.fs:app.fs*0.5
                width: parent.width-app.fs
                wrapMode: Text.WordWrap
                anchors.centerIn: parent
                color: 'white'
                visible: u!=='ricardo__martin'
            }
            MouseArea{
                anchors.fill: parent
                onClicked: xUserSettings.enabled=!xUserSettings.enabled
                visible: u!=='ricardo__martin'
            }
            Button{
                id: bot1
                text: '<'
                width: app.fs
                anchors.left: parent.left
                anchors.leftMargin: r.state==='hide'?0-bot1.width:0
                onClicked: {
                    r.state=r.state==='show'?'hide':'show'
                    //app.editable=false
                    //app.showMode(app.editable)
                }
                visible: u==='ricardo__martin'
            }
            Component.onCompleted: {
                e=xUserSettings.enabled
            }
//            function isEnabled(){
//                return xUserSettings.enabled
//            }
        }
    }
    Component.onCompleted: {
        addUser('ricardo__martin')
    }
    function addUser(user){
        let e=false
        for(var i=0;i<lm.count;i++){
            console.log('Dato:'+lm.get(i).u)
            if(user===lm.get(i).u){
                e=true
                break
            }
        }
        if(!e){
            lm.append(lm.addItem(user))
        }
    }
    function userIsEnabled(user){
        let e=true
        for(var i=0;i<lm.count;i++){
            //console.log('Dato isEnabled:'+lm.get(i).e)
            if(user===lm.get(i).u){
                e=lm.get(i).e
            }
        }
        return e
    }
}
