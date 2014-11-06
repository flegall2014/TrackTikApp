import QtQuick 2.3

Rectangle {
    width: 100*display.scale
    height: 62*display.scale
    property alias hour: hourSpin.value
    property alias minute: minuteSpin.value
    property alias second: secondSpin.value

    function setInitialTime(hour, minute, second)
    {
        hourSpin.setCurrentIndex(hour)
        minuteSpin.setCurrentIndex(minute)
        secondSpin.setCurrentIndex(second)
    }

    Row {
        anchors.fill: parent
        anchors.margins: 4*display.scale

        Spinner {
            id: hourSpin
            width: parent.width/3
            height: parent.height
            model: 24
            title: qsTr("Hour")
        }

        Spinner {
            id: minuteSpin
            width: parent.width/3
            height: parent.height
            model: 60
            title: qsTr("Minute")
        }

        Spinner {
            id: secondSpin
            width: parent.width/3
            height: parent.height
            model: 60
            title: qsTr("Second")
        }
    }
}
