import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import "../widgets"
import "../presentation"
import HttpUp 1.0
import CAPIConnection 1.0
import CAPIHandler 1.0

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
    }

    // Setup screen:
    FormBuilder {
        id: setupScreen
        width: parent.width
        height: parent.height
        form: dataMgr.buildForm(":/json/setup.json")
        visible: false
        state: setting.get("setup_done") ? "" : "on"
        states: State {
            name: "on"
            PropertyChanges {
                target: setupScreen
                visible: true
            }
        }
        Behavior on opacity {
            NumberAnimation {duration: 150}
        }

        // CAPI handler:
        capiHandler: CAPIHandler {
            id: setupHandler

            // Success:
            onSuccess: {
                // Get string response:
                var response = setupHandler.response()

                // Parse response:
                var jsonObject = JSON.parse(response)

                // Update setting:
                for (var i=0; i<jsonObject.data.length; i++)
                {
                    var item = jsonObject.data[i]
                    setting.set(item["name"],  item["value"]);
                }

                // Setup done:
                setting.set("setup_done", 1)

                // Set server url:
                setting.set("server_url", setupScreen.form.getFieldValue("url"));

                // Hide setup screen:
                setupScreen.state = "off"

                // Show signin screen:
                signInScreen.state = "on"
            }

            // Default impl:
            onError: errorMgr.showErrorMsg(error, setupHandler.errorString())

            // Progress changed:
            onProgressChanged: console.log("---------------------------------------------------------- PROGRESS: ", progress)
        }

        // Do API call:
        function doAPICall()
        {
            // Get server url:
            var url = form.getFieldValue("url")

            // Set handler:
            capiConnection.handler = setupHandler

            // Set API call:
            capiConnection.apiCall = form.getFieldProperty("parameters", "apicall")

            // Add code:
            capiConnection.addField("code", form.getFieldValue("code"))

            // Call:
            capiConnection.call(url)
        }
    }

    // Popup mgr:
    PopupMgr {
        id: popupMgr
    }

    // Error mgr:
    ErrorMgr {
        id: errorMgr
    }

    // Initial state:
    Component.onCompleted: {
        var test = setting.get("setup_done")
        var setupDone = test && (test === 1)
        setupScreen.state = setupDone ? "" : "on"
        signInScreen.state = setupDone ? "on" : ""
    }
}
