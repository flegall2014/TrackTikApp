import QtQuick 2.3
import QtQuick.Controls 1.2
import CAPIHandler 1.0

Rectangle {
    id: errorDialog
    width: application.width/2
    height: application.height/2
    color: "red"
    property alias titleColor: title.color
    property alias titleBold: title.font.bold
    property alias titleFontFamily: title.font.family
    property alias labelColor: errorLabel.color
    property alias labelBold: errorLabel.font.bold
    property alias labelFontFamily: errorLabel.font.family
    signal closeClicked()

    // Initialize using widget data:
    function initialize(error, errorString)
    {
        // Network error:
        if (error === CAPIHandler.NetworkError)
        {
            title.text = qsTr("Network Error")
            errorLabel.text = errorString
            errorDialog.color = "red"
        }
        else
        if (error === CAPIHandler.FileError)
        {
            title.text = qsTr("File Error")
            errorLabel.text = errorString
            errorDialog.color = "green"
        }
        else
        if (error === CAPIHandler.ApiError)
        {
            var jsonObject = JSON.parse(errorString)
            title.text = qsTr("API Error")
            errorLabel.text = jsonObject.data[0].description[0]
            errorDialog.color = "blue"
        }
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

    // Title:
    Label {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 32*display.scale
        font.pixelSize: 32*display.scale
    }

    Rectangle {
        color: "transparent"
        border.color: "black"
        anchors.centerIn: parent
        width: application.width/3
        height: application.height/3

        // Error label:
        Label {
            id: errorLabel
            anchors.centerIn: parent
            width: parent.width-32*display.scale
            color: "black"
            font.bold: true
            font.pixelSize: 18
            wrapMode: TextEdit.WordWrap
        }
    }
}
