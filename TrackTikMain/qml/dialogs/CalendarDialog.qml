import QtQuick 2.3
import QtQuick.Controls 1.2
import "../widgets"

Dialog {
    id: calendarDialog
    width: application.width/2
    height: application.height/2

    // Initialize using widget data:
    function initialize(form, fieldId)
    {
        calendarWidget.initialize(form, fieldId)
    }

    // Calendar:
    CalendarWidget {
        id: calendarWidget
        anchors.fill: parent
    }

    // Save:
    // See: PopupMgr::onSaveClicked()
    function save()
    {
        calendarWidget.save()
    }
}
