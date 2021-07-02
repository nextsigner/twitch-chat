import QtQuick 2.0

Rectangle {
    id: r
    anchors.fill: parent
    property string text: '?'
    Text {
        id: txt
        width: r.width-app.fs*2
        text: r.text
        font.pixelSize: app.fs*3
        wrapMode: Text.WordWrap
        anchors.centerIn: parent
    }
}
