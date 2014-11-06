import QtQuick 2.3
import QtQuick.Controls 1.2
import "../widgets"

Dialog {
    id: drawDialog
    width: application.width/2
    height: application.height/2
    property alias initialImage: drawWidget.initialImage

    // Extra controls:
    extraControls: Item {
        anchors.fill: parent
        ToolButton {
            text: qsTr("Clear")
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            onClicked: drawWidget.clear()
        }
    }

    // Initialize using widget data:
    function initialize(form, fieldId)
    {
        drawWidget.initialize(form, fieldId)
    }

    // Draw widget:
    DrawWidget {
        id: drawWidget
        anchors.fill: parent
    }

    // Save:
    // See: PopupMgr::onSaveClicked()
    function save()
    {
        drawWidget.save()
    }
}
