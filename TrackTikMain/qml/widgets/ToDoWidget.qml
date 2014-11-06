import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

BaseWidget {
    id: toDoWidget
    height: toDoWidgetStyle.height

    // Initialize:
    function initialize(form, fieldId)
    {
        toDoWidget.form = form
        toDoWidget.fieldId = fieldId

        var type = form.getFieldProperty(fieldId, "type")
        label.text = "TO DO: "
        if (type)
            label.text += type
    }

    // Style:
    ToDoWidgetStyle {
        id: toDoWidgetStyle
    }

    // Build widget:
    Item {
        anchors.fill: parent

        // Popup button:
        Rectangle {
            color: toDoWidgetStyle.bkgColor
            anchors.fill: parent
            Text {
                id: label
                anchors.centerIn: parent
                font.family: toDoWidgetStyle.labelFontFamily
                font.bold: toDoWidgetStyle.labelBold
                color: toDoWidgetStyle.labelColor
            }
        }
    }
}
