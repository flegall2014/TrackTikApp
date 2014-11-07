import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import "../widgets"
import "../presentation"
import HttpUp 1.0

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
        property string serverUrl: ""
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

        // Upload state changed:
        function onUpdloadStateChanged(uploadState, status, response)
        {
            // HTTP loader done:
            if (uploadState === HttpUploader.Done)
            {
                // Status OK:
                if (status === HttpUploader.OK)
                {
                    // Parse response:
                    var jsonObject = JSON.parse(response)

                    // Got success:
                    if (jsonObject.name === "success")
                    {
                        // Loop through the response.data
                        for (var i=0; i<jsonObject.data.length; i++)
                        {
                            var item = jsonObject.data[i]
                            var name = item["name"]
                            var value = item["value"]
                            session.set(name, value)
                        }

                        // Update setting:
                        //setting.set("setup_done", 1)
                        //setting.set("server_url", serverUrl);
                    }
                }
            }
        }

        // Progress changed:
        function onProgressChanged(progress)
        {
            console.log(progress)
        }

        // Network error:
        function onNetworkError(error)
        {
            console.log(error)
        }

        // Send request (overloaded):
        function sendRequest()
        {
            // Get url:
            serverUrl = form.getFieldValue("url")

            // Get code:
            var code = form.getFieldValue("code")

            // Get api code:
            var apiCall = form.getFieldProperty("parameters", "apicall")

            // Get type:
            var type = form.getFieldProperty("parameters", "type")

            // Full URL:
            var fullUrl = serverUrl+"/"+type+"/"+apiCall

            // Open:
            uploader.open(fullUrl);
            for (var i=0; i<form.nFields; i++)
            {
                // Get field name:
                var name = form.getFieldProperty(i, "name")
                if (name === "parameters")
                    continue

                // Get field value:
                var value = form.getFieldValue(i)

                // Add field:
                uploader.addField(name, value)
            }

            // Add field:
            uploader.addField("code", code);

            // Send:
            uploader.send()
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
