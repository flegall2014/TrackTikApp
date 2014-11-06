import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

PopupBaseWidget {
    id: popupDrawWidget
    height: popupDrawStyle.height

    // Initialize:
    function initialize(form, fieldId)
    {
        popupDrawWidget.form = form
        popupDrawWidget.fieldId = fieldId

        // Set label:
        var label = form.getFieldProperty(fieldId, "label")
        if (label)
            widgetLabel.text = label

        // Initialize draw area:
        var url = getValue()
        if (url !== undefined)
            image.source = url
    }

    // Style:
    PopupDrawStyle {
        id: popupDrawStyle
    }

    // Build widget:
    Item {
        id: column
        anchors.fill: parent
        Label {
            id: widgetLabel
            color: popupDrawStyle.labelColor
            font.bold: popupDrawStyle.labelBold
            font.family: popupDrawStyle.labelFontFamily
            width: parent.width
        }
        // Popup button:
        Rectangle {
            id: popupDraw
            width: parent.width
            anchors.top: widgetLabel.bottom
            anchors.topMargin: popupDrawStyle.spacing
            anchors.bottom: parent.bottom

            color: popupDrawStyle.bkgColor
            Image {
                id: image
                asynchronous: true
                anchors.centerIn: parent
                smooth: true
                height: parent.height
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: showPopup(form, fieldId)
            }
        }
    }

    // Update:
    function update(targetForm, targetFieldId)
    {
        // Remove QML warnings:
        if (popupDrawWidget === undefined)
            return
        var needUpdate = visible && (targetForm === form) && (targetFieldId === fieldId)
        if (needUpdate)
        {
            var url = getValue()
            if (url)
            {
                // Local file?
                var isLocal = false
                if (dataMgr.fileExists(url))
                    isLocal = true

                // Make it local:
                if (isLocal)
                    url = "file:///"+url
                image.source = url
            }
        }
    }
}
