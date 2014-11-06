import QtQuick 2.3
import QtQuick.Controls.Styles 1.2

BaseStyle {
    property Component style: ButtonStyle {
        background: Rectangle {
            implicitWidth: 100*display.scale
            implicitHeight: 25*display.scale
            border.width: control.activeFocus ? 2 : 1
            border.color: "#888"
            color: control.pressed ? "#111" : "#000"
        }
        label: Component {
            Text {
                text: control.text
                clip: true
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                color: "white"
                font.family: settings.fontFamily
                font.bold: true
            }
        }
    }
    property int buttonWidth: 256*display.scale
    property int buttonHeight: 32*display.scale
}
