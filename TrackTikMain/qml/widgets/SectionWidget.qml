import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

BaseWidget {
    id: sectionWidget
    height: sectionWidgetStyle.height

    // Initialize:
    function initialize(form, fieldId)
    {
        sectionWidget.form = form
        sectionWidget.fieldId = fieldId

        var label = form.getFieldProperty(fieldId, "label")
        if (label)
            widgetLabel.text = label
    }

    // Style:
    SectionWidgetStyle {
        id: sectionWidgetStyle
    }

    // Build widget:
    Item {
        id: column
        anchors.fill: parent
        Label {
            id: widgetLabel
            color: sectionWidgetStyle.labelColor
            font.bold: sectionWidgetStyle.labelBold
            font.family: sectionWidgetStyle.labelFontFamily
            width: parent.width
        }
        Rectangle {
            width: parent.width
            height: sectionWidgetStyle.separatorHeight
            color: sectionWidgetStyle.separatorColor
            anchors.top: widgetLabel.bottom
            anchors.topMargin: 8*display.scale
        }
    }
}
