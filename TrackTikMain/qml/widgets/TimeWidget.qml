import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

BaseWidget {
    id: calendarWidget
    height: timeWidgetStyle.height
    property string selectedTime

    // Initialize:
    function initialize(form, fieldId)
    {
        calendarWidget.form = form
        calendarWidget.fieldId = fieldId

        var time = form.getFieldValue(fieldId)
        if (time)
        {
            var res = time.split(":")
            var hour = parseInt(res[0])
            var minute = parseInt(res[1])
            var second = parseInt(res[2])
            timePicker.setInitialTime(hour, minute, second)
        }
    }

    // Style:
    TimeWidgetStyle {
        id: timeWidgetStyle
    }

    // Build widget:
    Item {
        anchors.fill: parent

        // Time widget:
        TimePicker {
            id: timePicker
            anchors.fill: parent
        }
    }

    // Save:
    function save()
    {
        var value = timePicker.hour+":"+timePicker.minute+":"+timePicker.second
        setValue(value)
    }
}
