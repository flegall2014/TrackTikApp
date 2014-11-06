import QtQuick 2.3
import QtQuick.Controls 1.2
import "../main"

Rectangle {
    id: dialog

    // Settings:
    Settings {
        id: settings
    }

    // Field id:
    property string fieldId: ""
    width: 320*display.scale
    height: 192*display.scale
    color: settings.dlgBckColor
    border.color: settings.dlgBorderColor
    border.width: settings.dlgBorderWidth

    // Signals:
    signal closeClicked()
    signal saveClicked()
    signal cancelClicked()

    // Default property:
    default property alias contents: contents.children
    property alias extraControls: extraControls.children

    // Top controls:
    Item {
        id: topControls
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 32*display.scale

        // Extra controls:
        Item {
            id: extraControls
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 4*display.scale
            anchors.right: close.left
            anchors.rightMargin: 4*display.scale
        }

        // Close
        ToolButton {
            id: close
            anchors.right: parent.right
            anchors.rightMargin: 4*display.scale
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Close")
            onClicked: closeClicked()
        }
    }

    // Bottom controls:
    Item {
        id: bottomControls
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 32*display.scale

        // Save:
        ToolButton {
            id: save
            anchors.right: cancel.left
            anchors.rightMargin: 4*display.scale
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Save")
            onClicked: saveClicked()
        }

        // Cancel:
        ToolButton {
            id: cancel
            anchors.right: parent.right
            anchors.rightMargin: 4*display.scale
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Cancel")
            onClicked: cancelClicked()
        }
    }

    // Contents:
    Item {
        id: contents
        anchors.top: topControls.bottom
        anchors.bottom: bottomControls.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    // Initialize:
    function initialize(form, fieldId)
    {
        // Base impl does nothing:
    }

    // Save:
    // See: PopupMgr::onSaveClicked()
    function save()
    {
        // Base impl does nothing:
    }
}
