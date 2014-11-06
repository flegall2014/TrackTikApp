import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

BaseWidget {
    id: textInputWidget

    // Set height, otherwise, default to: settings.defaultWidgetHeight
    height: textInputStyle.height

    // Initialize:
    function initialize(form, fieldId)
    {
        textInputWidget.form = form
        textInputWidget.fieldId = fieldId

        var label = form.getFieldProperty(fieldId, "label")
        if (label)
            widgetLabel.text = label
        var hint = form.getFieldProperty(fieldId, "hint")
        if (hint)
            widgetInput.placeholderText = hint
        var value = form.getFieldValue(fieldId)
        if (value)
            widgetInput.text = value
        var subType = form.getFieldProperty(fieldId, "subType")
        if (subType && (subType === "NUMBER"))
            widgetInput.validator = doubleValidator
    }

    // Style:
    TextInputStyle {
        id: textInputStyle
    }

    // Double validator:
    DoubleValidator {
        id: doubleValidator
    }

    // Build widget:
    Item {
        id: column
        anchors.fill: parent
        Label {
            id: widgetLabel
            color: textInputStyle.labelColor
            font.bold: textInputStyle.labelBold
            font.family: textInputStyle.labelFontFamily
            width: parent.width
        }
        TextField {
            id: widgetInput
            width: parent.width
            anchors.top: widgetLabel.bottom
            anchors.topMargin: textInputStyle.spacing
            anchors.bottom: parent.bottom
            onTextChanged: setValue(text)
        }
    }
}
