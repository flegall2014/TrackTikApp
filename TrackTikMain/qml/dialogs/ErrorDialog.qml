import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle {
    id: errorDialog
    width: application.width/2
    height: application.height/2
    color: "red"
    property alias labelColor: errorLabel.color
    property alias labelBold: errorLabel.font.bold
    property alias labelFontFamily: errorLabel.font.family
    signal closeClicked()

    // Initialize using widget data:
    function initialize(errorString)
    {
        errorLabel.text = errorString
    }

    // Close
    ToolButton {
        id: close
        anchors.right: parent.right
        anchors.rightMargin: errorDialog.border.width+4*display.scale
        anchors.top: parent.top
        anchors.topMargin: errorDialog.border.width+4*display.scale
        text: qsTr("Close")
        onClicked: closeClicked()
    }

    // Error label:
    Label {
        id: errorLabel
        anchors.centerIn: parent
        color: "black"
        font.bold: true
        font.pixelSize: 18
        wrapMode: TextEdit.WordWrap
    }
}
