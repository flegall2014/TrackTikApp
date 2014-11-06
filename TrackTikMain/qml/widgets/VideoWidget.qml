import QtQuick 2.3
import QtMultimedia 5.0
import QtQuick.Controls 1.2
import "../styles"
import "./camera"

BaseWidget {
    id: videoWidget
    height: videoWidgetStyle.height
    property string photoPath: ""

    // Initialize:
    function initialize(form, fieldId)
    {
        videoWidget.form = form
        videoWidget.fieldId = fieldId
    }

    // Style:
    VideoWidgetStyle {
        id: videoWidgetStyle
    }

    // Camera:
    TrackTikCamera {
        id: camera
        anchors.fill: parent
        onPhotoCaptured: {
            videoWidget.photoPath = photoPath
        }
    }

    // Save:
    function save()
    {
        if (dataMgr.fileExists(videoWidget.photoPath))
            // Set value:
            setValue(videoWidget.photoPath)
    }
}
