import QtQuick 2.3
import QtQuick.Layouts 1.1

// User Section:
Rectangle {
    id: userStatus
    Layout.preferredHeight: 80*display.scale
    Layout.minimumHeight: 80*display.scale
    color: settings.colorBackgroundDark
    property alias userName: userName.text
    property alias userPicture: userPicture.source

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10*display.scale
        anchors.rightMargin: 10*display.scale
        spacing: 10*display.scale

        // User picture:
        Image {
            id: userPicture
            Layout.preferredHeight: 60*display.scale
            Layout.preferredWidth: 60*display.scale
            fillMode: Image.PreserveAspectCrop
            cache: true
            asynchronous: true
        }

        ColumnLayout {
            height: parent.height
            Layout.fillWidth: true

            Text {
                id: userName
                color: settings.colorFontLightGrey
                font.bold: true
                font.pixelSize: 15*display.scale
            }
            Text {
                id: sign_out
                text: qsTr("Sign Out")
                color: settings.colorFontLightGrey
                font.pixelSize: 12*display.scale
                font.weight: Font.Light

                MouseArea {
                    anchors.fill: parent;
                    hoverEnabled: true
                    //onHoveredChanged: userStatus.color = "red"
                    onClicked: application.signedIn = false
                }
            }
        }
    }
}
