import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import "../communication"

// Container
Rectangle {
    id : listWrapper
    // Visibility
    visible: true
    anchors.fill: parent

    // Constant @todo Replace with real constants??
    property string new_window: "new_window";
    property string split_window: "splitwindow";

    // Transparency
    color: "transparent"

    // The delegate
    property Component internalDelegate;

    // Title & icons
    property string viewTitle : ""

    // Api call
    property string apicall : "";

    // Target View
    property string targetView;

    // Taget method
    property string targetMethod;

    // Communication
    Communication {
        id: comm
        onReceived: {
            listModel.generateFromJson(jsonObject);
        }
    }

    // Column
    ColumnLayout {
        anchors.fill: parent

        ListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: listModel
            clip: true
            keyNavigationWraps: true
            highlightMoveDuration: 0
            focus: true
            snapMode: ListView.SnapToItem

            Component.onCompleted: {
                comm.getJSON(apicall, true)
            }

            // Header with title
            header : ListHeader{
                title : viewTitle
            }

            // Delegate template
            // How to move this in the settings
            delegate: Rectangle{
                width: parent.width
                height: display.scale(80)
                anchors.left: parent.left
                anchors.right: parent.right
                Loader {
                    anchors.fill: parent
                    sourceComponent: listWrapper.internalDelegate
                    Component.onCompleted: {

                    }
                    property QtObject modelData: model
                }
            }
        }
    }

    // JSON Adapter
    ListModel {
        id: listModel
        function generateFromJson(jsonObject) {
            for (var i = 0; i < jsonObject.data.length; i++)
                listModel.append(jsonObject.data[i]);
        }
    }
}
