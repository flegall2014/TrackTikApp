import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

BaseWidget {
    id: passwordInputWidget

    // Set height, otherwise, default to: settings.defaultWidgetHeight
    height: passwordInputStyle.height

    // Initialize:
    function initialize(form, fieldId)
    {
        passwordInputWidget.form = form
        passwordInputWidget.fieldId = fieldId

        var label = form.getFieldProperty(fieldId, "label")
        if (label)
            widgetLabel.text = label
        var hint = form.getFieldProperty(fieldId, "hint")
        if (hint)
            widgetInput.placeholderText = hint
        var value = form.getFieldValue(fieldId)
        if (value)
            widgetInput.text = value
    }

    // Style:
    PasswordInputStyle {
        id: passwordInputStyle
    }

    // Build widget:
    Item {
        id: column
        anchors.fill: parent
        Label {
            id: widgetLabel
            color: passwordInputStyle.labelColor
            font.bold: passwordInputStyle.labelBold
            font.family: passwordInputStyle.labelFontFamily
            width: parent.width
        }
        TextField {
            id: widgetInput
            echoMode: passwordInputStyle.textHidden ? TextInput.Password : TextInput.Normal
            width: parent.width
            anchors.top: widgetLabel.bottom
            anchors.topMargin: passwordInputStyle.spacing
            anchors.bottom: parent.bottom
            onTextChanged: setValue(text)
        }
    }
}
