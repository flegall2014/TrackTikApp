import QtQuick 2.3
import "../main"

// Single widget interface:
Item {
    id: baseWidget
    anchors.left: parent.left
    anchors.leftMargin: 8*display.scale
    anchors.right: parent.right
    anchors.rightMargin: 8*display.scale
    height: settings.defaultWidgetHeight
    property variant form

    // Field id:
    property string fieldId: ""
    signal showPopup(variant form, string fieldId)

    // Settings:
    Settings {
        id: settings
    }

    // Get value:
    function getValue()
    {
        return form.getFieldValue(fieldId)
    }

    // Set value:
    function setValue(value)
    {
        form.setFieldValue(fieldId, value)
    }

    // Get label:
    function getValueLabel()
    {
        return form.getFieldValueLabel(fieldId)
    }

    // Initialize:
    function initialize(form, fieldId)
    {
        // Base impl does nothing:
    }

    // Save:
    function save()
    {
        // Base impl does nothing:
    }

    // Update:
    function update(targetForm, targetFieldId)
    {
        // Base impl does nothing:
    }

    // Form changed: listen to update signals:
    onFormChanged: form.update.connect(update)
}
