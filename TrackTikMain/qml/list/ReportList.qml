import QtQuick 2.3

ApiList {
    // Api call
    apicall : "report/Getcustomreportlist"
    viewTitle: "Create a report"

    // TO DO?
    // Cache the results for this number of seconds
    //cacheDuration : 600

    // Name of payload
    //dataPackageName: "ReportListPayload"

    // Delegate
    internalDelegate: ListDelegate{
        line1: modelData.description
        line2: modelData.details
    }
}
