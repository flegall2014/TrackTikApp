import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

BaseWidget {
    id: submitButtonWidget

    // Clicked signal:
    signal clicked()

    // Set height, otherwise, default to: settings.defaultWidgetHeight
    height: submitButtonStyle.height

    // Initialize:
    function initialize(form, fieldId)
    {
        submitButtonWidget.form = form
        submitButtonWidget.fieldId = fieldId

        var submitLabel = form.getFieldProperty(fieldId, "submitLabel")
        if (submitLabel)
            submitButton.text = submitLabel
    }

    // Style:
    SubmitButtonStyle {
        id: submitButtonStyle
    }

    // Build widget:
    Item {
        anchors.fill: parent

        // Submit button:
        Button {
            id: submitButton
            style: submitButtonStyle.style
            anchors.fill: parent
            onClicked: submitButtonWidget.clicked()
        }
    }
}
