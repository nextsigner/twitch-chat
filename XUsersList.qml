import QtQuick 2.0
import Qt.labs.settings 1.1

Rectangle {
    id: r
    width: parent.width*0.5
    height: parent.height
    border.width: 2
    border.color: 'red'
    property alias listModel: lm
    ListView{
        id: lv
        anchors.fill: r
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
            width: r.width-app.fs
            height: txtUser.contentHeight+app.fs
            border.width: xUserSettings.enabled?4:1
            border.color: 'blue'
            color: 'black'
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
            }
            MouseArea{
                anchors.fill: parent
                onClicked: xUserSettings.enabled=!xUserSettings.enabled
            }
            Component.onCompleted: {
                e=xUserSettings.enabled
            }
//            function isEnabled(){
//                return xUserSettings.enabled
//            }
        }
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
