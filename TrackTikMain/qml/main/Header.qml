import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle {
    id: banner
    height: 50*display.scale
    color: settings.headerColor

    // Navigation arrow:
    ToolButton {
        id: arrow
        iconSource: "qrc:/qml/images/ico-leftarrow.png"
        anchors.left: banner.left
        anchors.leftMargin: 20*display.scale
        height: 24*display.scale
        width: 24*display.scale
        anchors.verticalCenter: banner.verticalCenter
        visible: slideDeck.currentSlide > 0

        // Change slide:
        MouseArea {
            anchors.fill: parent
            onClicked: slideDeck.goToPreviousSlide()
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
        color: "transparent"
        height: parent.height
        opacity: (slideDeck.viewModeSmall && slideDeck.currentSlide == 0) ? 1 : 0
        visible: (slideDeck.viewModeSmall && slideDeck.currentSlide == 0) ? true : false

        // Show menu button:
        Image {
            id: menuButton
            source: "qrc:/qml/images/ico-elipse.png"
            height: 18*display.scale
            width: 8*display.scale
            anchors.verticalCenter: parent.verticalCenter
            opacity: slideDeck.viewModeSmall && slideDeck.currentSlide == 0 ? 1 : 0
            Behavior on opacity {
                PropertyAnimation{}
            }
        }

        // Show hide menu:
        MouseArea {
            anchors.fill: parent
            onClicked: slideDeck.updateMenu()
        }
    }
}
