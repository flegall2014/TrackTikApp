import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import "../widgets"
import "../presentation"

// Main application:
Item {
    id: application

    // Setup done?
    property bool setupDone: false

    // User signed in?
    property bool userSignedIn: false

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
            when: setupDone && userSignedIn
            PropertyChanges {
                target: signInScreen
                visible: false
                y: -application.height
            }
        }
        Behavior on y {
            NumberAnimation {duration: 150}
        }
    }

    // Setup screen:
    FormBuilder {
        id: setupScreen
        width: parent.width
        height: parent.height
        form: dataMgr.buildForm(":/json/setup.json")
        states: State {
            name: "off"
            when: setupDone
            PropertyChanges {
                target: setupScreen
                visible: false
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

    Component.onCompleted: {
        var test = session.get("setup_done")
        setupDone = test && (test === true)
    }
}
