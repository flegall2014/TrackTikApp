import QtQuick 2.3
import QtMultimedia 5.0

FocusScope {
    property Camera camera
    property bool previewAvailable : false

    property int buttonsPanelWidth: buttonPaneShadow.width
    property string photoPath: dataMgr.homeDir+"/image_"+dataMgr.generateUID()+".jpg"
    signal previewSelected
    signal videoModeSelected
    id: captureControls

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
                text: "Capture"
                visible: camera.imageCapture.ready
                onClicked: {
                    camera.imageCapture.captureToLocation(photoPath)
                    cameraUI.photoCaptured(photoPath)
                }
            }

            CameraPropertyButton {
                id : wbModesButton
                value: CameraImageProcessing.WhiteBalanceAuto
                model: ListModel {
                    ListElement {
                        icon: "images/camera_auto_mode.png"
                        value: CameraImageProcessing.WhiteBalanceAuto
                        text: "Auto"
                    }
                    ListElement {
                        icon: "images/camera_white_balance_sunny.png"
                        value: CameraImageProcessing.WhiteBalanceSunlight
                        text: "Sunlight"
                    }
                    ListElement {
                        icon: "images/camera_white_balance_cloudy.png"
                        value: CameraImageProcessing.WhiteBalanceCloudy
                        text: "Cloudy"
                    }
                    ListElement {
                        icon: "images/camera_white_balance_incandescent.png"
                        value: CameraImageProcessing.WhiteBalanceTungsten
                        text: "Tungsten"
                    }
                    ListElement {
                        icon: "images/camera_white_balance_flourescent.png"
                        value: CameraImageProcessing.WhiteBalanceFluorescent
                        text: "Fluorescent"
                    }
                }
                onValueChanged: captureControls.camera.imageProcessing.whiteBalanceMode = wbModesButton.value
            }

            CameraButton {
                text: "View"
                onClicked: captureControls.previewSelected()
                visible: captureControls.previewAvailable
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
                text: "Switch to Video"
                onClicked: captureControls.videoModeSelected()
            }
        }
    }

    ZoomControl {
        x : 0
        y : 0
        width: 100*display.scale
        height: parent.height

        currentZoom: camera.digitalZoom
        maximumZoom: Math.min(4.0, camera.maximumDigitalZoom)
        onZoomTo: camera.setDigitalZoom(value)
    }
}
