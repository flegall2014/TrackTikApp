import QtQuick 2.3
import QtQuick.Controls 1.2
import "../widgets"

Dialog {
    id: listDialog
    width: application.width/2
    height: application.height/2

    // Initialize using widget data:
    function initialize(form, fieldId)
    {
        listViewWidget.initialize(form, fieldId)
    }

    // List widget:
    ListViewWidget {
        id: listViewWidget
        anchors.fill: parent
    }

    // Save:
    // See: PopupMgr::onSaveClicked()
    function save()
    {
        listViewWidget.save()
    }
}
