import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQml.Models 2.1
import QtQuick.Layouts 1.1
import "../"

Rectangle {
    color: settings.colorBackgroundDark

    // Behavior on x:
    Behavior on x {
        PropertyAnimation{}
    }

    // Main layout:
    ColumnLayout {
        width: parent.width
        height: parent.height

        // User status:
        UserStatus {
            id: userStatus
            width: parent.width
        }

        // List View:
        ListView {
            id: leftMenuView
            model: LayoutMenuItemModel {}
            anchors.left: parent.left
            anchors.leftMargin: 8*display.scale
            anchors.right: parent.right
            Layout.fillHeight: true
            snapMode: ListView.SnapToItem
            delegate: Rectangle {
                id: menuDelegate
                width: parent.width
                height: 40*display.scale
                color: leftMenuView.currentIndex === index ? "#a31b23" : "transparent"

                // Behavior on color:
                Behavior on color {
                    ColorAnimation {duration: 200}
                }

                Row {
                    spacing: 8*display.scale
                    anchors.fill: parent

                    // Icon:
                    Text {
                        text: icon
                        font.family: "FontAwesome"
                        color: settings.colorFontLightGrey
                        font.pixelSize: 18*display.scale
                        Layout.preferredWidth: 40*display.scale
                        horizontalAlignment: Text.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Text:
                    Text {
                        text: name
                        color: settings.colorFontLightGrey
                        font.pixelSize: 18*display.scale
                        Layout.fillWidth: true
                        Layout.alignment: Layout.Right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent;
                    hoverEnabled: true
                    onEntered: leftMenuView.currentIndex = index
                    onClicked: {
                        // TO DO
                        /*
                        mainWindow.menuOpened = false
                        stackList.loadParent(source, {})
                        */
                    }
                }
            }
        }
    }

    // Signed in changed:
    function onSignedInChanged()
    {
        userStatus.userPicture = session.get("user_picture")
        userStatus.userName = session.get("user_name")
    }

    // Listen to signed in notification:
    Component.onCompleted: application.signedInChanged.connect(onSignedInChanged)
}
