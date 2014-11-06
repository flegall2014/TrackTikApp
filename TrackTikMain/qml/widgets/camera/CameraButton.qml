import QtQuick 2.3

Item {
    id: button

    signal clicked

    property string text
    property color color: "white"

    width: 144*display.scale
    height: 70*display.scale

    BorderImage {
        id: buttonImage
        source: "images/toolbutton.sci"
        width: button.width; height: button.height
    }
    MouseArea {
        id: mouseRegion
        anchors.fill: buttonImage
        onClicked: { button.clicked(); }
    }
    Text {
        id: btnText
        color: button.color
        anchors.centerIn: buttonImage; font.bold: true
        text: button.text; style: Text.Raised; styleColor: "black"
        font.pixelSize: 14
    }
}
