import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle {
    id: banner
    height: 50*display.scale
    color: settings.headerColor

    ToolButton {
        id: arrow
        iconSource: "qrc:/qml/images/icon-left-arrow.png"
        anchors.left: banner.left
        anchors.leftMargin: 20*display.scale
        height: 12*display.scale
        width: 12*display.scale
        anchors.verticalCenter: banner.verticalCenter
        //visible: viewStack.currentIndex !=0

        MouseArea {
            anchors.fill: parent
            onClicked: {
                viewStack.decrementCurrentIndex()
            }
        }
    }

    Image {
        cache: true
        asynchronous: true
        source: "http://tracktik.com/images/tracktik_main_logo.png"
        anchors.centerIn: parent
        opacity: 0.8
        height: 24*display.scale
        width: 90*display.scale
    }

    Rectangle {

        anchors.left: parent.left
        anchors.leftMargin: 15*display.scale
        width: 25*display.scale
        color:"transparent"
        height: parent.height
        opacity: application.viewModeSmall && viewStack.currentIndex ==0?1:0
        visible: application.viewModeSmall && viewStack.currentIndex ==0?true:false

        Image {
            id: menuButton
            source: "qrc:/qml/images/elipse.png"
            height: 18*display.scale
            width: 8*display.scale
            anchors.verticalCenter: parent.verticalCenter
            opacity: application.viewModeSmall && viewStack.currentIndex ==0?1:0
            Behavior on opacity {
                PropertyAnimation{}
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainWindow.menuOpened = !mainWindow.menuOpened
            }
        }
    }
}
