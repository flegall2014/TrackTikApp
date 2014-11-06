import QtQuick 2.3
import QtQuick.Controls 1.2
import "../widgets"

Dialog {
    id: videoDialog
    width: application.width/2
    height: application.height/2

    // Initialize using widget data:
    function initialize(form, fieldId)
    {
        videoWidget.initialize(form, fieldId)
    }

    // Video widget:
    VideoWidget {
        id: videoWidget
        anchors.fill: parent
    }

    // Save:
    // See: PopupMgr::onSaveClicked()
    function save()
    {
        videoWidget.save()
    }
}
