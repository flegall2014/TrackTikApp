import QtQuick 2.3
import "../styles"

// Popup mgr:
Loader {
    id: errorMgr
    anchors.centerIn: parent
    property variant form
    property string fieldId: ""
    property string type: ""
    property int error: 0 // None=0, FileError=1, NetworkError=2, ApiError=3
    property string errorMsg: ""

    // Error dialog style:
    ErrorDialogStyle {
        id: style
    }

    // Show error msg:
    function showErrorMsg(error, errorMsg)
    {
        errorMgr.error = error
        errorMgr.errorMsg = errorMsg
        errorMgr.source = "../dialogs/ErrorDialog.qml"
    }

    // Close current dialog:
    function closeActiveDialog()
    {
        // Reset loader source:
        errorMgr.source = ""
    }

    // Close clicked:
    function onCloseClicked()
    {
        closeActiveDialog()
    }

    // Callbacks:
    onLoaded: {
        item.border.color = style.borderColor
        item.border.width = style.borderWidth
        item.titleColor = style.titleColor
        item.titleBold = style.titleBold
        item.titleFontFamily = style.labelFontFamily
        item.labelColor = style.labelColor
        item.labelBold = style.labelBold
        item.labelFontFamily = style.labelFontFamily
        item.closeClicked.connect(onCloseClicked)
        item.initialize(errorMgr.error, errorMgr.errorMsg)
    }
}

