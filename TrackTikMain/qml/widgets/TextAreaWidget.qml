import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

BaseWidget {
    id: testAreaWidget

    // Set height, otherwise, default to: settings.defaultWidgetHeight
    height: textAreaStyle.height

    // Initialize:
    function initialize(form, fieldId)
    {
        testAreaWidget.form = form
        testAreaWidget.fieldId = fieldId

        var label = form.getFieldProperty(fieldId, "label")
        if (label)
            widgetLabel.text = label
        var value = form.getFieldValue(fieldId)
        if (value)
            widgetInput.text = value
    }

    // Style:
    TextAreaStyle {
        id: textAreaStyle
    }

    // Build widget:
    Item {
        id: column
        anchors.fill: parent
        Label {
            id: widgetLabel
            color: textAreaStyle.labelColor
            font.bold: textAreaStyle.labelBold
            font.family: textAreaStyle.labelFontFamily
            width: parent.width
        }
        TextArea {
            id: widgetInput
            width: parent.width
            anchors.top: widgetLabel.bottom
            anchors.topMargin: textAreaStyle.spacing
            anchors.bottom: parent.bottom
            onTextChanged: setValue(text)
        }
    }
}
