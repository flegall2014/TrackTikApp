import QtQuick 2.3

// List of postorders:
ApiList{
    apicall : "postorder/Getsubjects"
    viewTitle: "Post Orders"

    // Delegate
    internalDelegate: ListDelegate{
        line1 : modelData.description
        line2 : modelData.last_modified
    }
}
