import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

BaseWidget {
    id: checkBoxWidget
    height: checkBoxWidgetStyle.height

    // Initialize:
    function initialize(form, fieldId)
    {
        checkBoxWidget.form = form
        checkBoxWidget.fieldId = fieldId
        var label = form.getFieldProperty(fieldId, "label")
        if (label)
            checkBoxButton.text = label
        var checked = form.getFieldValue(fieldId)
        if (checked)
            checkBoxButton.checked = (checked !== 0)
    }

    // Style:
    CheckBoxWidgetStyle {
        id: checkBoxWidgetStyle
    }

    // Build widget:
    Item {
        anchors.fill: parent

        // Check box:
        CheckBox {
            id: checkBoxButton
            anchors.verticalCenter: parent.verticalCenter
            onCheckedChanged: setValue(checked)
        }
    }
}
