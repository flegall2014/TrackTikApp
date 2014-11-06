import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle {
    id: spinner
    width: 360*display.scale
    height: 360*display.scale
    color: "black"
    property alias model: list.model
    property alias title: label.text
    property int value: 0

    function setCurrentIndex(index)
    {
        list.currentIndex = index
        list.positionViewAtIndex(index, ListView.Center)
    }

    Label {
        id: label
        anchors.bottom: spinnerRect.top
        anchors.bottomMargin: 8
        elide: Text.ElideMiddle
        font.bold: true
        font.pixelSize: 18
        anchors.horizontalCenter: spinnerRect.horizontalCenter
        color: "white"
    }

    Rectangle {
        id: spinnerRect

        anchors.centerIn: parent
        width: parent.width
        height: width
        radius: 20
        color: "gray"

        ListView {
            id: list
            anchors.fill: parent
            clip: true
            highlightFollowsCurrentItem: true
            highlightRangeMode: ListView.StrictlyEnforceRange
            snapMode: ListView.SnapToItem
            delegate: Rectangle{
              width: list.width
              height: list.height
              color: "transparent"
              rotation: (index % 2) ? -10 : 10

              Text {
                  anchors.centerIn: parent
                  horizontalAlignment: Text.AlignHCenter
                  text: index
                  font.pixelSize: list.width-8
              }
            }

            onCurrentIndexChanged: spinner.value = currentIndex
            onMovementEnded: {
                list.currentIndex = list.visibleArea.yPosition * (list.count+1)
            }
        }

        Rectangle {
            id: overlay
            anchors.fill: parent
            gradient: Gradient {
                 GradientStop { position: 0.0; color: "black" }
                 GradientStop { position: 0.18; color: "transparent" }
                 GradientStop { position: 0.33; color: "white" }
                 GradientStop { position: 0.66; color: "transparent" }
                 GradientStop { position: 1.0; color: "black" }
            }
        }
    }
}
