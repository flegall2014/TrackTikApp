import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: propertyButton
    property alias value : popup.currentValue
    property alias model : popup.model

    width: 144*display.scale
    height: 70*display.scale

    BorderImage {
        id: buttonImage
        source: "images/toolbutton.sci"
        width: propertyButton.width; height: propertyButton.height
    }

    CameraButton {
        anchors.fill: parent
        Image {
            anchors.centerIn: parent
            source: popup.currentItem.icon
        }

        onClicked: popup.toggle()
    }

    CameraPropertyPopup {
        id: popup
        anchors.right: parent.left
        anchors.rightMargin: 16
        anchors.top: parent.top
        state: "invisible"
        visible: opacity > 0

        currentValue: propertyButton.value

        states: [
            State {
                name: "invisible"
                PropertyChanges { target: popup; opacity: 0 }
            },

            State {
                name: "visible"
                PropertyChanges { target: popup; opacity: 1.0 }
            }
        ]

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 100 }
        }

        function toggle() {
            if (state == "visible")
                state = "invisible";
            else
                state = "visible";
        }

        onSelected: {
            popup.state = "invisible"
        }
    }
}

