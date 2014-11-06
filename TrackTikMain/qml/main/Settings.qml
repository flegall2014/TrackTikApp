import QtQuick 2.3

Item {
    id : application

    // Colors:
    readonly property string colorBackgroundDark: "#454E59"
    readonly property string headerColor: "#292F35"
    readonly property string colorFontDarkGrey: "#555"
    readonly property string colorFontLightGrey: "#DDD"
    readonly property string presentationBkgColor: "#EBEEFE"

    // Font:
    readonly property string fontFamily: "Segoe UI"

    // Default widget height:
    readonly property int defaultWidgetHeight: 64*display.scale

    // Dialog properties:
    readonly property string dlgBckColor: "lightgray"
    readonly property string dlgBorderColor: "gray"
    readonly property int dlgBorderWidth: 3*display.scale

    FontLoader {
        source: "../fonts/fontawesome-webfont.ttf"
    }

    FontLoader {
        source: "../fonts/Roboto-Regular.ttf"
    }

    FontLoader {
        source: "../fonts/Roboto-Bold.ttf"
    }

    FontLoader {
        source: "../fonts/Roboto-Light.ttf"
    }
}
