import QtQuick 2.3

ListModel {
    ListElement {
        name: "Checkpoints"
        source : "/content/list/CheckpointList.qml"
        icon : "\uf02a"
    }
    ListElement {
        name: "Reports"
        source: "list/ReportList.qml"
        icon: "\uf1c2"
    }
    ListElement {
        name: "Post Orders"
        source: "list/PostOrdersList.qml"
        icon: "\uf046"
    }
    ListElement {
        name: "Camera Test"
        source: "list/CameraTest.qml"
        icon: "\uf046"
    }
    ListElement {
        name: "Camera Test"
        source: "form/fields/FieldSignature.qml"
        icon: "\uf046"
    }
}
