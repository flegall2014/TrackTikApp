import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import "../"

ApiList{
    // Call
    apicall: "checkpointtour/getnexttours"

    // The Title
    viewTitle: "List of Scheduled Tours"

    // OnClick
    targetView: "/content/CheckpointListDetails.qml"

    // Template
    internalDelegate: ListRowCounterDelegate {
        line1: modelData.description
        line2: modelData.last_performed
        counter_color: modelData.time < (new Date()).getTime()? application.colorSuccess : application.colorDanger
        counter_text: modelData.schedule_time
    }
}

