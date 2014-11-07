import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import HttpUp 1.0

Rectangle {
    id: container
    color: settings.colorBackgroundDark

    // Form (from DataMgr):
    property variant form
    enabled: (popupMgr.status === Loader.Null)

    // HTPP uploader:
    HttpUploader {
        id: uploader

        // Upload state changed:
        onUploadStateChanged: {
            if (uploadState == HttpUploader.Done) {
                console.log("Upload done with status " + status, responseText);
                console.log("Error is "  + errorString)
            }
        }

        // Progress changed:
        onProgressChanged: {
            console.log("Upload progress = " + progress)
        }

        // Monitor network errors:
        onNetworkErrorChanged: {
            console.log(networkError)
        }
    }

    // Form  changed:
    onFormChanged: {
        // Setup title area:
        setupTitleArea()

        // Set model:
        widgetView.model = form.nFields
    }

    // Setup title area:
    function setupTitleArea()
    {
        titleLabel.text = form.getFieldProperty("parameters", "title")
        detailsLabel.text = form.getFieldProperty("parameters", "details")
    }

    // Get loader source:
    function getSource(index)
    {
        // Get type:
        var type = form.getFieldProperty(index, "type").toLowerCase()
        var listType = "strings"
        if (type === "list")
            listType = form.getFieldProperty(index, "listType")

        // Draw widget?
        var isDrawWidget = ((type === "signature") ||
            (type === "draw_car") || (type === "draw_injury") || (type === "draw_trailer") || (type === "draw_golf_cart")
                || (type === "picture"))

        // Need popup?
        var isMultiple = false
        if (type === "list") {
            var test = form.getFieldProperty(index, "isMultiple")
            isMultiple = (test && (test !== 0))
        }

        // Need popup: yes for multiple list, date, picture, drawwidget:
        var needPopup = (isMultiple || (type === "date") || (type === "time") || (type === "picture") || isDrawWidget)
        if (needPopup)
            return isDrawWidget ? "../widgets/PopupDrawWidget.qml" : "../widgets/PopupButtonWidget.qml"

        if ((type === "text") || (type === "autocomplete"))
            return "../widgets/TextInputWidget.qml"
        if (type === "textarea")
            return "../widgets/TextAreaWidget.qml"
        if (type === "password")
            return "../widgets/PasswordInputWidget.qml"
        if (type === "checkbox")
            return "../widgets/CheckBoxWidget.qml"
        if (type === "section")
            return "../widgets/SectionWidget.qml"
        if (type === "list")
            return "../widgets/ComboWidget.qml"
        if (type === "api")
            return "../widgets/SubmitButtonWidget.qml"

        // Default:
        return "../widgets/ToDoWidget.qml"
    }

    //
    // Form callbacks:
    //

    // API button clicked:
    function sendRequest()
    {
        // Get url:
        var url = form.getFieldValue("url")

        // Get api code:
        var apiCall = form.getFieldProperty("parameters", "apicall")

        // Get type:
        var type = form.getFieldProperty("parameters", "type")

        // Get code:
        var code = "1124L078" //form.getFieldValue("code")

        // Full URL:
        var fullUrl = url+"/"+type+"/"+apiCall

        // Open:
        uploader.open(fullUrl);

        for (var i=0; i<form.nFields; i++)
        {
            // Get field name:
            var name = form.getFieldProperty(i, "name")

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

    // Request OK:
    function onRequestOK()
    {
        // Check API call:
        var apiCall = form.getFieldProperty("parameters", "apicall")

        // Sign-in? set main application state:
        if (apiCall === "signin")
            application.state = "signedIn"
    }

    // Request error:
    function onRequestError()
    {

    }

    /*
    // Logo:
    Image {
        id: logoArea
        cache: true
        asynchronous: true
        source: "http://tracktik.com/images/tracktik_main_logo.png"
        opacity: 0.8
        width: 90*display.scale
        height: 24*display.scale
        anchors.top: parent.top
        anchors.topMargin: 4*display.scale
        anchors.horizontalCenter: parent.horizontalCenter
    }
    */

    // Title area:
    Column {
        id: titleArea
        width: parent.width/2
        anchors.top: parent.top
        anchors.topMargin: 4*display.scale
        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            id: titleLabel
            visible: text.length > 0
            color: "white"
            font.bold: true
            font.family: settings.fontFamily
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: detailsLabel
            visible: text.length > 0
            color: "white"
            font.bold: true
            font.family: settings.fontFamily
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Show popup:
    function showPopup(form, fieldId)
    {
        // Show appropriate popup based on field id:
        popupMgr.showPopup(form, fieldId)
    }

    // Slide area:
    Item {
        id: slideArea
        width: parent.width
        anchors.top: titleArea.bottom
        anchors.topMargin: 4*display.scale
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4*display.scale

        ScrollView {
            anchors.fill: parent

            // List view:
            ListView {
                id: widgetView
                anchors.fill: parent
                spacing: 8*display.scale
                clip: true
                delegate: Loader {
                    width: parent.width
                    source: getSource(index)
                    onLoaded: {
                        // Initialize:
                        item.initialize(form, form.getFieldId(index))

                        // Show popup:
                        item.showPopup.connect(showPopup)

                        // Is this item associated with an API call?
                        // Check API call:
                        var type = form.getFieldProperty(index, "type").toLowerCase()
                        if (type === "api")
                        {
                            item.clicked.connect(sendRequest)
                            form.requestOK.connect(onRequestOK)
                            form.requestError.connect(onRequestError)
                        }
                    }
                }
            }
        }
    }
}
