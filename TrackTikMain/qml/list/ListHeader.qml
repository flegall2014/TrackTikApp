import QtQuick 2.3

Rectangle {
    width:parent.width
    height: display.scale(60)

    property string title

    Rectangle {
        anchors.left: parent.left
        height: parent.height
        width: parent.width
        color: "#454e59"
        Text{
           anchors.fill: parent
           text: title
           color: "#ddd"
           opacity: 0.8
           anchors.margins: display.scale(22)
           font.pixelSize: display.scale(22)
           font.bold: true
           verticalAlignment: Text.AlignVCenter
        }
    }
}
