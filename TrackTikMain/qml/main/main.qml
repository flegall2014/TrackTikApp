import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import "../widgets"
import "../presentation"

// Main application:
Item {
    id: application

    // States:
    states: [
        State {
            name: "signedIn"
        }
    ]

    // Settings:
    Settings {
        id: settings
    }

    // Shrinks UI:
    function uiZoomOut() {
        display.decrZoom()
    }

    // Enlarges UI:
    function uiZoomIn() {
        display.incrZoom()
    }

    // Slide deck:
    SlideDeck {
        id: slideDeck
        visible: application.state === "signedIn"
        anchors.fill: parent
        forms: [":/json/aaa.json", ":/json/bbb.json", ":/json/ccc.json"]
        mouseAreaEnabled: (popupMgr.status === Loader.Null)
    }

    // Sign-in screen:
    FormBuilder {
        id: signInScreen
        width: parent.width
        height: parent.height
        form: dataMgr.buildForm(":/json/signin.json")
        states: State {
            name: "off"
            when: application.state === "signedIn"
            PropertyChanges {
                target: signInScreen
                y: -application.height
            }
        }
        Behavior on y {
            NumberAnimation {duration: 150}
        }
    }

    // Popup mgr:
    PopupMgr {
        id: popupMgr
    }
}
