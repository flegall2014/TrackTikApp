import QtQuick 2.3
import QtQuick.Layouts 1.1

Rectangle {
    id: footer
    height: 50*display.scale
    color: settings.headerColor

    // ensures no click events reach through to items in behind
    MouseArea {
        anchors.fill: parent
    }

    RowLayout {
        anchors.fill: parent

        Item {
            Layout.fillWidth: true
        }

        Text {
            id: zoomMinus

            text: "\uf147"
            font.family: "FontAwesome"
            color: settings.colorFontDarkGrey
            font.pixelSize: 16*display.scale
            Layout.preferredWidth: 20*display.scale
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: application.uiZoomOut()
            }
        }

        Text {
            id: zoomPlus

            text: "\uf196"
            font.family: "FontAwesome"
            color: settings.colorFontDarkGrey
            font.pixelSize: 16*display.scale
            Layout.preferredWidth: 20*display.scale
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: application.uiZoomIn()
            }
        }
    }
}
