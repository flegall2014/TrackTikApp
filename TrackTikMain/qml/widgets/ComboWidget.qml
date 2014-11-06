import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

BaseWidget {
    id: comboWidget
    height: comboWidgetStyle.height
    property string listType: ""

    // Combo model:
    ListModel {
        id: comboModel
    }

    // Initialize:
    function initialize(form, fieldId)
    {
        comboWidget.form = form
        comboWidget.fieldId = fieldId

        // Get list type:
        listType = form.getFieldProperty(fieldId, "listType")
        if (listType === undefined)
            listType = "strings"

        // Get label:
        var label = form.getFieldProperty(fieldId, "label")
        if (label)
            widgetLabel.text = label

        // Get list:
        var list = form.getFieldProperty(fieldId, "list")

        if (list)
        {
            // Values list:
            var nItems = list.length
            for (var i=0; i<nItems; i++)
            {
                if (listType === "values")
                    comboModel.append({"label": list[i].label})
                else
                    comboModel.append({"label": list[i]})
            }
        }

        // Set model:
        combo.model = comboModel
    }

    // Style:
    ComboWidgetStyle {
        id: comboWidgetStyle
    }

    // Build widget:
    Item {
        id: stringList
        anchors.fill: parent
        Label {
            id: widgetLabel
            color: comboWidgetStyle.labelColor
            font.bold: comboWidgetStyle.labelBold
            font.family: comboWidgetStyle.labelFontFamily
            width: parent.width
        }
        ComboBox {
            id: combo
            textRole: "label"
            width: parent.width
            anchors.top: widgetLabel.bottom
            anchors.topMargin: comboWidgetStyle.spacing
            anchors.bottom: parent.bottom
            onCurrentTextChanged: {
                if (listType === "values")
                {
                    var list = form.getFieldProperty(fieldId, "list")
                    if (list && (list.length > 0))
                        setValue(list[currentIndex].value)
                } else setValue(currentText)
            }
        }
    }
}
