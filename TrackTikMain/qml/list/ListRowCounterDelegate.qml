import QtQuick 2.3
import QtQuick.Layouts 1.1

Rectangle {
    id: delegate

    property string targetView
    property string targetMethod
    property string line1
    property string line2
    property string counter_color
    property int counter_width
    property string counter_text

    width: parent.width
    height:parent.height

    RowLayout {
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                stackList.load(targetView,model);
            }
        }

        Rectangle{
            id: counter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: display.scale(100)
            anchors.left: parent.left
            anchors.margins: display.scale(10)
            color: counter_color

            Text{
                text : counter_text
                color : "#fff"
                font.pixelSize: display.scale(30)
                font.bold: true
                anchors.centerIn: counter
            }
        }

        Text {
            id: textLine1
            anchors.top: parent.top
            anchors.topMargin: display.scale(15)
            anchors.left: counter.right
            anchors.leftMargin: display.scale(15)
            anchors.right: parent.right
            height: display.scale(40)
            color: "#000000"
            font.pixelSize: display.scale(24)
            text: line1
        }

        Text {
            id: textLine2
            anchors.top: textLine1.bottom
            anchors.left: counter.right

            anchors.leftMargin: display.scale(15)
            anchors.rightMargin: display.scale(15)
            anchors.right: parent.right
            height: display.scale(40)

            color: "#555"
            font.pixelSize: display.scale(18)
            font.weight: Font.Light

            text: line2

        }

        Rectangle {
            id: endingLine
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: display.scale(1)
            color: "#d7d7d7"
        }
    }
}
