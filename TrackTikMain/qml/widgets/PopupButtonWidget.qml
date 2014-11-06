import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

PopupBaseWidget {
    id: popupButtonWidget
    height: popupButtonStyle.height
    property var locale: Qt.locale()

    // Initialize:
    function initialize(form, fieldId)
    {
        popupButtonWidget.form = form
        popupButtonWidget.fieldId = fieldId

        // Set label:
        var label = form.getFieldProperty(fieldId, "label")
        if (label)
            widgetLabel.text = label
        var type = form.getFieldProperty(fieldId, "type")
        var isList = type ? ((type === "list") ||(type === "strings")) : false

        // Set value labels:
        var valueLabels = form.getFieldValueLabel(fieldId)
        if (valueLabels)
        {
            if (isList)
                popupButton.text = valueLabels.join()
            else
                popupButton.text = valueLabels
        }
    }

    // Style:
    PopupButtonStyle {
        id: popupButtonStyle
    }

    // Build widget:
    Item {
        id: column
        anchors.fill: parent
        Label {
            id: widgetLabel
            color: popupButtonStyle.labelColor
            font.bold: popupButtonStyle.labelBold
            font.family: popupButtonStyle.labelFontFamily
            width: parent.width
        }
        // Popup button:
        Button {
            id: popupButton
            style: popupButtonStyle.style
            width: parent.width
            anchors.top: widgetLabel.bottom
            anchors.topMargin: popupButtonStyle.spacing
            anchors.bottom: parent.bottom
            onClicked: showPopup(form, fieldId)
        }
    }

    // Update:
    function update(targetForm, targetFieldId)
    {
        // Remove QML warnings:
        if (popupButtonWidget === undefined)
            return
        var needUpdate = visible && (targetForm === form) && (targetFieldId === fieldId)
        if (needUpdate) {
            var type = form.getFieldProperty(fieldId, "type")
            var isList = type ? ((type === "list") ||(type === "strings")) : false

            // Set value labels:
            var valueLabels = form.getFieldValueLabel(fieldId)
            if (valueLabels)
            {
                if (isList)
                    popupButton.text = valueLabels.join()
                else
                    popupButton.text = valueLabels
            }
        }
    }
}
