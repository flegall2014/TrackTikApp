import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

BaseWidget {
    id: calendarWidget
    height: calendarWidgetStyle.height

    // Initialize:
    function initialize(form, fieldId)
    {
        calendarWidget.form = form
        calendarWidget.fieldId = fieldId
        var date = form.getFieldValue(fieldId)
        if (date)
            calendar.selectedDate = date
    }

    // Style:
    CalendarWidgetStyle {
        id: calendarWidgetStyle
    }

    // Build widget:
    Item {
        anchors.fill: parent

        // Calendar:
        Calendar {
            id: calendar
            anchors.fill: parent
            frameVisible: calendarWidgetStyle.frameVisible
            weekNumbersVisible: calendarWidgetStyle.weekNumbersVisible
        }
    }

    // Save:
    function save()
    {
        setValue(calendar.selectedDate)
    }
}
