import QtQuick 2.3
import QtMultimedia 5.0

FocusScope {
    property Camera camera
    property bool previewAvailable : false

    property int buttonsPanelWidth: buttonPaneShadow.width

    signal previewSelected
    signal photoModeSelected
    id : captureControls

    Rectangle {
        id: buttonPaneShadow
        width: buttonsColumn.width + 16*display.scale
        height: parent.height
        anchors.top: parent.top
        anchors.right: parent.right
        color: Qt.rgba(0.08, 0.08, 0.08, 1)

        Column {
            anchors {
                right: parent.right
                top: parent.top
                margins: 8*display.scale
            }

            id: buttonsColumn
            spacing: 8*display.scale

            FocusButton {
                camera: captureControls.camera
                visible: camera.cameraStatus == Camera.ActiveStatus && camera.focus.isFocusModeSupported(Camera.FocusAuto)
            }

            CameraButton {
                text: "Record"
                visible: camera.videoRecorder.recorderStatus == CameraRecorder.LoadedStatus
                onClicked: camera.videoRecorder.record()
            }

            CameraButton {
                id: stopButton
                text: "Stop"
                visible: camera.videoRecorder.recorderStatus == CameraRecorder.RecordingStatus
                onClicked: camera.videoRecorder.stop()
            }

            CameraButton {
                text: "View"
                onClicked: captureControls.previewSelected()
                //don't show View button during recording
                visible: camera.videoRecorder.actualLocation && !stopButton.visible
            }
        }

        Column {
            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: 8*display.scale
            }

            id: bottomColumn
            spacing: 8*display.scale

            CameraButton {
                text: "Switch to Photo"
                onClicked: captureControls.photoModeSelected()
            }

            CameraButton {
                id: quitButton
                text: "Quit"
                onClicked: Qt.quit()
            }
        }
    }


    ZoomControl {
        x: 0
        y: 0
        width: 100*display.scale
        height: parent.height

        currentZoom: camera.digitalZoom
        maximumZoom: Math.min(4.0, camera.maximumDigitalZoom)
        onZoomTo: camera.setDigitalZoom(value)
    }
}
