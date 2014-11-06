import QtQuick 2.3
import QtQuick.Controls 1.2
import List 1.0
import "../styles"

BaseWidget {
    id: listViewWidget

    // Set height, otherwise, default to: settings.defaultWidgetHeight
    height: listViewStyle.height

    // List type?
    property string listType: "strings"

    // Selection:
    List {
        id: selection
    }

    // List model:
    ListModel {
        id: listModel
    }

    // Initialize:
    function initialize(form, fieldId)
    {
        listViewWidget.form = form
        listViewWidget.fieldId = fieldId

        // Check list type:
        var listType = form.getFieldProperty(fieldId, "listType")
        if (listType === undefined)
            listType = "strings"

        // Get list:
        var list = form.getFieldProperty(fieldId, "list")

        // Get initial values:
        var values = getValue()

        // Values list:
        var nItems = list.length
        var selected = false
        for (var i=0; i<nItems; i++)
        {
            if (listType === "values")
            {
                selected = values ? (values.indexOf(list[i].value) === -1 ? false : true) : false
                listModel.append({"label": list[i].label, "value": list[i].value, "selected": selected})
            }
            else
            {
                selected = values ? (values.indexOf(list[i]) === -1 ? false : true) : false
                listModel.append({"label": list[i], "value": list[i], "selected": selected})
            }
        }

        listView.model = listModel
    }

    // Style:
    ListViewStyle {
        id: listViewStyle
    }

    // Build widget:
    Item {
        id: multiList
        anchors.fill: parent
        ScrollView {
            anchors.fill: parent
            ListView {
                id: listView
                anchors.fill: parent
                spacing: listViewStyle.delegateSpacing
                clip: true
                delegate: Rectangle {
                    width: parent.width
                    height: listViewStyle.delegateHeight
                    color: (listView.currentIndex === index) ? listViewStyle.highlightColor : listViewStyle.delegateColor

                    MouseArea {
                        anchors.fill: parent
                        onClicked: listView.currentIndex = index
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 4*display.scale
                        anchors.right: checkBox.left
                        anchors.rightMargin: 4*display.scale
                        anchors.verticalCenter: parent.verticalCenter
                        text: label
                        elide: Text.ElideRight
                    }

                    CheckBox {
                        id: checkBox
                        anchors.right: parent.right
                        anchors.rightMargin: 4*display.scale
                        anchors.verticalCenter: parent.verticalCenter
                        checked: selected
                        onCheckedChanged: {
                            // Set current index:
                            listView.currentIndex = index

                            // Read current values:
                            var currentValues = getValue()
                            if (checked)
                            {
                                if (!selection.contains(value))
                                    selection.add(value)
                            }
                            else
                            {
                                // Find and remove item from an array
                                if (selection.contains(value))
                                    selection.remove(value)
                            }
                            selected = checked
                        }
                    }
                }
            }
        }
    }

    // Save:
    function save()
    {
        setValue(selection.values)
    }
}
