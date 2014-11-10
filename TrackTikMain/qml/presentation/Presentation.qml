import QtQuick 2.3
import QtQuick.Window 2.0

Item {
    id: root

    property variant slides: []
    property int currentSlide;
    property bool showNotes: false;
    property bool allowDelay: true;
    property color titleColor: textColor;
    property color textColor: "black"
    property string fontFamily: "Helvetica"
    property string codeFontFamily: "Courier New"
    property alias mouseAreaEnabled: mouseArea.enabled

    onCurrentSlideChanged: console.log(currentSlide)

    // Private API:
    property bool _faded: false
    property int _userNum;

    // Completed:
    Component.onCompleted: {
        var slideCount = 0;
        var slides = [];
        for (var i=0; i<root.children.length; ++i) {
            var r = root.children[i];
            if (r.isSlide) {
                slides.push(r);
            }
        }

        root.slides = slides;
        root._userNum = 0;

        // Make first slide visible...
        if (root.slides.length > 0) {
            root.currentSlide = 0;
            root.slides[root.currentSlide].visible = true;
        }
    }

    // Switch slides:
    function switchSlides(from, to, forward) {
        from.visible = false
        to.visible = true
        return true
    }

    // Go to next slide:
    function goToNextSlide() {
        root._userNum = 0
        if (_faded)
            return
        if (root.slides[currentSlide].delayPoints) {
            if (root.slides[currentSlide]._advance())
                return;
        }
        if (root.currentSlide + 1 < root.slides.length) {
            var from = slides[currentSlide]
            var to = slides[currentSlide + 1]
            if (switchSlides(from, to, true)) {
                currentSlide = currentSlide + 1;
                root.focus = true;
            }
        }
    }

    // Go to previous slide:
    function goToPreviousSlide() {
        root._userNum = 0
        if (root._faded)
            return
        if (root.currentSlide - 1 >= 0) {
            var from = slides[currentSlide]
            var to = slides[currentSlide - 1]
           if (switchSlides(from, to, false)) {
                currentSlide = currentSlide - 1;
               root.focus = true;
           }
        }
    }

    // Go to user slide:
    function goToUserSlide() {
        --_userNum;
        if (root._faded || _userNum >= root.slides.length)
            return
        if (_userNum < 0)
            goToNextSlide()
        else if (root.currentSlide != _userNum) {
            var from = slides[currentSlide]
            var to = slides[_userNum]
           if (switchSlides(from, to, _userNum > currentSlide)) {
                currentSlide = _userNum;
               root.focus = true;
           }
        }
    }

    // Go to slide index:
    function goToSlide(slideIndex) {
        root._userNum = 0
        if (root._faded)
            return
        if (slideIndex === currentSlide)
            return
        if ((slideIndex < 0) || (slideIndex > (slides.length-1)))
            return
        var from = slides[currentSlide]
        var to = slides[slideIndex]
        if (switchSlides(from, to, false)) {
            currentSlide = slideIndex;
            root.focus = true;
        }
    }

    focus: true

    Keys.onSpacePressed: goToNextSlide()
    Keys.onRightPressed: goToNextSlide()
    Keys.onDownPressed: goToNextSlide()
    Keys.onLeftPressed: goToPreviousSlide()
    Keys.onUpPressed: goToPreviousSlide()
    Keys.onEscapePressed: Qt.quit()
    Keys.onPressed: {
        if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9)
            _userNum = 10 * _userNum + (event.key - Qt.Key_0)
        else {
            if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter)
                goToUserSlide();
            else if (event.key == Qt.Key_Backspace)
                goToPreviousSlide();
            else if (event.key == Qt.Key_C)
                root._faded = !root._faded;
            _userNum = 0;
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (mouse.button == Qt.RightButton)
                goToPreviousSlide()
            else
                goToNextSlide()
        }
        // A back mechanism for touch only devices:
        onPressAndHold: goToPreviousSlide()
    }

    Window {
        id: notesWindow;
        width: 400
        height: 300

        title: "QML Presentation: Notes"
        visible: root.showNotes

        Text {
            anchors.fill: parent
            anchors.margins: parent.height * 0.1;

            font.pixelSize: 16
            wrapMode: Text.WordWrap

            property string notes: root.slides[root.currentSlide].notes;
            text: notes == "" ? "Slide has no notes..." : notes;
            font.italic: notes == "";
        }
    }
}
