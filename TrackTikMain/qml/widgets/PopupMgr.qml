import QtQuick 2.3

// Popup mgr:
Loader {
    id: popupMgr
    anchors.centerIn: parent
    property variant form
    property string fieldId: ""
    property string type: ""

    // Show popup:
    function showPopup(form, fieldId)
    {
        // Set form:
        popupMgr.form = form

        // Set field id:
        popupMgr.fieldId = fieldId

        // Get type:
        type = form.getFieldProperty(fieldId, "type")

        // Draw widget?
        var isDrawWidget = ((type === "signature") || (type === "draw_car") || (type === "draw_injury") || (type === "draw_trailer") || (type === "draw_golf_cart"))

        // Check type:
        if (isDrawWidget)
            popupMgr.source = "../dialogs/DrawDialog.qml"
        else
        if (type === "list")
            popupMgr.source = "../dialogs/ListDialog.qml"
        else
        if (type === "date")
            popupMgr.source = "../dialogs/CalendarDialog.qml"
        else
        if (type === "time")
            popupMgr.source = "../dialogs/TimeDialog.qml"
        else
        if (type === "picture")
            popupMgr.source = "../dialogs/VideoDialog.qml"
    }

    // Close current dialog:
    function closeActiveDialog()
    {
        // Reset loader source:
        popupMgr.source = ""
    }

    // Close clicked:
    function onCloseClicked()
    {
        closeActiveDialog()
    }

    // Save clicked:
    function onSaveClicked()
    {
        item.save()
        closeActiveDialog()
    }

    // Cancel clicked:
    function onCancelClicked()
    {
        closeActiveDialog()
    }

    // Callbacks:
    onLoaded: {

        // Listen to signals:
        item.closeClicked.connect(onCloseClicked)
        item.saveClicked.connect(onSaveClicked)
        item.cancelClicked.connect(onCancelClicked)

        // Get value:
        var value = form.getFieldValue(fieldId)

        // Pass required image in this case:
        if ((type === "draw_car") || (type === "draw_injury") ||
            (type === "draw_trailer") || (type === "draw_golf_cart"))
        {
            // Draw widget?
            item.initialImage = value ? value : form.getFieldProperty(fieldId, "map_type")
        }
        else if (type === "signature")
        {
            if (value)
                item.initialImage = value
        }

        // Set field id:
        item.initialize(form, fieldId)
    }
}

