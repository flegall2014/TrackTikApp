import QtQuick 2.3

Text {
    id: counter;

    property real fontSize: parent.height * 0.05
    property real fontScale: 0.5;
    property color textColor: parent.textColor !== undefined ? parent.textColor : "black"
    property string fontFamily: parent.fontFamily !== undefined ? parent.fontFamily : "Helvetica"

    text: "# " + (parent.currentSlide + 1) + " / " + parent.slides.length;
    color: counter.textColor;
    font.family: counter.fontFamily;
    font.pixelSize: fontSize * fontScale;

    anchors.right: parent.right;
    anchors.bottom: parent.bottom;
    anchors.margins: font.pixelSize;
}
