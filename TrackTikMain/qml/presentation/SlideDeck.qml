import QtQuick 2.3
import "../main"

Item {
    anchors.fill: parent
    property alias forms: deck.forms
    property alias mouseAreaEnabled: deck.mouseAreaEnabled

    // Small view mode:
    readonly property int viewModeSmallWidth: 750*display.scale
    property bool viewModeSmall: application.width < viewModeSmallWidth

    // Settings:
    Settings {
        id: settings
    }

    // application header
    Header {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
    }

    /*
    // The Stack library
    ListModel {
        id: stackList

        // Load a page
        function load(page, params) {

            // Insert the data
            insert(count, {source:page, data:params});
            viewStack.positionViewAtEnd();
            viewStack.forceLayout();

            // current view which will be parent of list
            var view = viewStack.currentItem;
            // load the QML file
            var component = Qt.createComponent(page);
            if(component.status != Component.Ready){
                console.log(component.errorString())
            }
            // create an instance
            var rect = component.createObject(view,{});
            rect.anchors.fill = view;
        }

        // Load a page at the beginning of the stack. This will delete the stack
        function loadParent(page, params) {
            clear();
            load(page, params);
        }
    }
    */

    // Presentation:
    Presentation {
        id: deck
        anchors.left: leftMenu.right
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: footer.top
        anchors.margins: viewModeSmall ? 0 : 20*display.scale
        textColor: "white"
        property bool inTransition: false
        property variant fromSlide
        property variant toSlide
        property int transitionTime: 500
        property variant forms

        // Load initial forms:
        onFormsChanged: dataMgr.buildForms(forms)

        // Default bkg:
        Rectangle {
            anchors.fill: parent
            color: settings.presentationBkgColor
            /*
            gradient: Gradient {
                GradientStop { position: 0; color: "lightsteelblue" }
                GradientStop { position: 1; color: "black" }
            }
            */
        }

        // Form builder:
        Component {
            id: formComponent
            FormBuilder {
                id: formBuilder
            }
        }

        // Form loader:
        Repeater {
            id: formView
            model: dataMgr.nForms
            anchors.fill: parent

            // Slide:
            TrackTikSlide {
                id: slide
                anchors.fill: parent
                Loader {
                    id: formLoader
                    sourceComponent: formComponent
                    anchors.fill: parent
                    onLoaded: {
                        item.form = dataMgr.form(index)
                        slide.title = item.form.getParameter("apicall")
                    }
                }
            }
        }

        // Forward animation:
        Component {
            id: fComp
            SequentialAnimation {
                id: forwardTransition
                PropertyAction { target: deck; property: "inTransition"; value: true }
                PropertyAction { target: deck.toSlide; property: "visible"; value: true }
                ParallelAnimation {
                    NumberAnimation { target: deck.fromSlide; property: "opacity"; from: 1; to: 0; duration: deck.transitionTime; easing.type: Easing.OutQuart }
                    NumberAnimation { target: deck.fromSlide; property: "scale"; from: 1; to: 1.1; duration: deck.transitionTime; easing.type: Easing.InOutQuart }
                    NumberAnimation { target: deck.toSlide; property: "opacity"; from: 0; to: 1; duration: deck.transitionTime; easing.type: Easing.InQuart }
                    NumberAnimation { target: deck.toSlide; property: "scale"; from: 0.7; to: 1; duration: deck.transitionTime; easing.type: Easing.InOutQuart }
                }
                PropertyAction { target: deck.fromSlide; property: "visible"; value: false }
                PropertyAction { target: deck.fromSlide; property: "scale"; value: 1 }
                PropertyAction { target: deck; property: "inTransition"; value: false }
            }
        }

        // Backward animation:
        Component {
            id: bComp
            SequentialAnimation {
                id: backwardTransition
                running: false
                PropertyAction { target: deck; property: "inTransition"; value: true }
                PropertyAction { target: deck.toSlide; property: "visible"; value: true }
                ParallelAnimation {
                    NumberAnimation { target: deck.fromSlide; property: "opacity"; from: 1; to: 0; duration: deck.transitionTime; easing.type: Easing.OutQuart }
                    NumberAnimation { target: deck.fromSlide; property: "scale"; from: 1; to: 0.7; duration: deck.transitionTime; easing.type: Easing.InOutQuart }
                    NumberAnimation { target: deck.toSlide; property: "opacity"; from: 0; to: 1; duration: deck.transitionTime; easing.type: Easing.InQuart }
                    NumberAnimation { target: deck.toSlide; property: "scale"; from: 1.1; to: 1; duration: deck.transitionTime; easing.type: Easing.InOutQuart }
                }
                PropertyAction { target: deck.fromSlide; property: "visible"; value: false }
                PropertyAction { target: deck.fromSlide; property: "scale"; value: 1 }
                PropertyAction { target: deck; property: "inTransition"; value: false }
            }
        }

        // Forward animation loader:
        Loader {
            id: fLoader
        }

        // Backward animation loader:
        Loader {
            id: bLoader
        }

        // Switch to slide:
        function switchSlides(from, to, forward)
        {
            if (deck.inTransition)
                return false

            deck.fromSlide = from
            deck.toSlide = to

            fLoader.sourceComponent = fComp
            bLoader.sourceComponent = bComp

            if (forward)
                fLoader.item.running = true
            else
                bLoader.item.running = true

            return true
        }
    }

    // Responsive left menu:
    LayoutLeftMenu {
        id: leftMenu
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        x: viewModeSmall ? -width : 0
        width: 220*display.scale
    }

    // Footer:
    Footer {
        id: footer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 30*display.scale
    }
}
