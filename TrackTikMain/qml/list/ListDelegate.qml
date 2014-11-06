import QtQuick 2.3
import QtQuick.Layouts 1.1

Rectangle {
    id: delegate

    property string targetView
    property string targetMethod
    property string line1
    property string line2
    width: parent.width
    height: display.scale(80)

    RowLayout {
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                stackList.load(targetView,model);
            }
        }

        Text {
            id: textLine1
            anchors.top: parent.top
            anchors.topMargin: display.scale(15)
            anchors.left: parent.left
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
            anchors.left: parent.left
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
