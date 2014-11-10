import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import HttpUp 1.0
import CAPIHandler 1.0
import CAPIConnection 1.0

Rectangle {
    id: container
    color: settings.colorBackgroundDark

    // Form (from DataMgr):
    property variant form
    enabled: ((popupMgr.status === Loader.Null) && (errorMgr.status === Loader.Null))

    // Default CAPI handler, can be overriden:
    property var capiHandler: CAPIHandler {
        id: capiHandler

        // Default impl:
        onSuccess: console.log("DEFAULT SUCCESS = ", success)

        // Default impl:
        onError: errorMgr.showErrorMsg(error, capiHandler.errorString())

        // Default impl:
        onProgressChanged: console.log("DEFAULT PROGRESS = ", progress)
    }

    // CAPI connection:
    property var capiConnection: CAPIConnection {
        id: capiConnection
        handler: capiHandler
        onBusyChanged: application.showBusyIndicator(busy)
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

    // Default doAPICall:
    function doAPICall()
    {
        // Get server url:
        var url = setting.get("server_url")

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
                            item.clicked.connect(doAPICall)
                    }
                }
            }
        }
    }
}
