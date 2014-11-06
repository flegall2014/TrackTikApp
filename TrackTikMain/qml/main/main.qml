import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import "../widgets"
import "../presentation"
import HttpUp 1.0

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

    /* TEST PURPOSE ONLY
    HttpUploader {
        id: theUploader

        onUploadStateChanged: {
            if( uploadState == HttpUploader.Done ) {
                console.log("Upload done with status " + status, responseText);
                console.log("Error is "  + errorString)
            }
        }

        onProgressChanged: {
            console.log("Upload progress = " + progress)
        }

        Component.onCompleted: {
            theUploader.open("https://abc.staffr.com");
            theUploader.addField("name", "Dooom !!!!");
            theUploader.addFile("filetoUpload", ":/qml/main/main.qml");
            theUploader.send()
        }
    }
    */

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

    /*
    // Setup screen:
    FormBuilder {
        id: setupScreen
        width: parent.width
        height: parent.height
        visible: true//session.get("setup_done") === false
        form: dataMgr.buildForm(":/json/setup.json")
        states: State {
            name: "off"
            when: application.state === "signedIn"
            PropertyChanges {
                target: setupScreen
                y: -application.height
            }
        }
        Behavior on y {
            NumberAnimation {duration: 150}
        }
    }
    */

    // Popup mgr:
    PopupMgr {
        id: popupMgr
    }
}
