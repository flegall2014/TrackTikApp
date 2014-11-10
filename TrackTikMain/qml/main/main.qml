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

    // Setup done?
    property bool setupDone: setting.get("setup_done")

    // Signed in?
    property bool signedIn: false

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
        visible: signedIn
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
        visible: setupDone && !signedIn

        // CAPI handler:
        capiHandler: CAPIHandler {
            id: signinHandler

            // Success:
            onSuccess: {
                // Get string response:
                var response = signinHandler.response()

                console.log(response)

                // Parse response:
                var jsonObject = JSON.parse(response)

                // Read api:
                for (var key in jsonObject.attributes.api)
                    session.set("api_"+key, jsonObject.attributes.api[key])

                // Read user:
                for (key in jsonObject.attributes.user)
                    session.set("user_"+key, jsonObject.attributes.user[key])

                // Signed in:
                signedIn = true
            }

            // Default impl:
            onError: errorMgr.showErrorMsg(error, signinHandler.errorString())

            // Progress changed:
            onProgressChanged: console.log("---------------------------------------------------------- PROGRESS: ", progress)
        }

        // Do API call:
        function doAPICall()
        {
            // Set handler:
            capiConnection.handler = signinHandler

            // Set API call:
            capiConnection.apiCall = form.getFieldProperty("parameters", "apicall")

            // Loop through all fields:
            for (var i=0; i<form.nFields; i++)
            {
                // Get field name/value:
                var fieldName = form.getFieldProperty(i, "name")
                var fieldValue = form.getFieldValue(fieldName)

                // Don't care about parameters:
                if (fieldName === "parameters")
                    continue

                // Add code:
                capiConnection.addField(fieldName, fieldValue)
            }

            // Call:
            capiConnection.call()
        }
    }

    // Setup screen:
    FormBuilder {
        id: setupScreen
        width: parent.width
        height: parent.height
        form: dataMgr.buildForm(":/json/setup.json")
        visible: !setupDone

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
                setupDone = true

                // Set server url:
                setting.set("server_url", setupScreen.form.getFieldValue("url"));

                // Hide setup screen:
                setupScreen.state = ""
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

    // Busy indicator:
    BusyIndicator {
        id: indicator
        z: 1000
        width: parent.width/10
        height: parent.height/10
        anchors.centerIn: parent
        running: false
        visible: false
    }

    // Show busy indicator:
    function showBusyIndicator(busy)
    {
        if (busy)
        {
            indicator.visible = true
            indicator.running = true
        }
        else
        {
            indicator.visible = false
            indicator.running = false
        }
    }

    // Initial state:
    Component.onCompleted: {
        var test = setting.get("setup_done")
        var setupDone = test && (test === 1)
        setupScreen.state = setupDone ? "" : "on"
        signInScreen.state = setupDone ? "on" : ""
    }
}
