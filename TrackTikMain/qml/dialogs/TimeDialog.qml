import QtQuick 2.3
import QtQuick.Controls 1.2
import "../widgets"

Dialog {
    id: timeDialog
    width: application.width/3
    height: application.width/5

    // Initialize using widget data:
    function initialize(form, fieldId)
    {
        timeWidget.initialize(form, fieldId)
    }

    // Time:
    TimeWidget {
        id: timeWidget
        anchors.fill: parent
    }

    // Save:
    // See: PopupMgr::onSaveClicked()
    function save()
    {
        timeWidget.save()
    }
}
