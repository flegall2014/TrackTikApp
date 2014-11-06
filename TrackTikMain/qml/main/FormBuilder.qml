import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    id: container
    color: settings.colorBackgroundDark

    // Form (from DataMgr):
    property variant form
    enabled: (popupMgr.status === Loader.Null)

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
        titleLabel.text = form.getParameter("title")
        detailsLabel.text = form.getParameter("details")
    }

    // Get loader source:
    function getSource(index)
    {
        // Get type:
        var type = form.getFieldProperty(index, "type")
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
        if (type === "API")
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
        // Notify form (C++):
        form.sendRequest()
    }

    // Request OK:
    function onRequestOK()
    {
        // Check API call:
        var apiCall = form.getParameter("apicall")

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
            color: "white"
            font.bold: true
            font.family: settings.fontFamily
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: detailsLabel
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
                        var type = form.getFieldProperty(index, "type")
                        if (type === "API")
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
