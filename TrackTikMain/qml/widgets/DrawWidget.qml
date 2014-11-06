import QtQuick 2.3
import QtQuick.Controls 1.2
import "../styles"

BaseWidget {
    id: drawWidget

    // Set height, otherwise, default to: settings.defaultWidgetHeight
    height: drawWidgetStyle.height

    // Canvas properties:
    property int paintX
    property int paintY
    property int count: 0
    property int lineWidth: 2*display.scale
    property string initialImage: ""
    property string type: ""

    // Initialize:
    function initialize(form, fieldId)
    {
        drawWidget.form = form
        drawWidget.fieldId = fieldId

        // Read type:
        type = form.getFieldProperty(fieldId, "type")

        // Local file?
        var isLocal = false
        if (dataMgr.fileExists(initialImage))
            isLocal = true

        // Make it local:
        if (isLocal)
            initialImage = "file:///"+initialImage

        // Set source component:
        canvasLoader.sourceComponent = canvasComponent
    }

    // Save:
    function save()
    {
        // Grab a default file:
        var defaultFile = dataMgr.homeDir()+"/image_"+dataMgr.generateUID()+".png"

        // Save:
        canvasLoader.item.save(defaultFile)

        // Set value:
        setValue(defaultFile)
    }

    // Clear:
    function clear()
    {
        canvasLoader.item.clear()
    }

    // Canvas component:
    Component {
        id: canvasComponent
        Canvas {
            id: canvas
            width: drawWidget.width
            height: drawWidget.height

            // Clear:
            function clear()
            {
                var ctx = canvas.getContext("2d")
                ctx.beginPath()
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                if (type === "signature")
                    initialImage = ""
                else initialImage = form.getFieldProperty(fieldId, "map_type")
                canvas.requestPaint()
            }

            antialiasing: true
            property real lastX
            property real lastY
            Component.onCompleted: {
                var ctx = canvas.getContext("2d")
                ctx.beginPath()
                loadImage(initialImage)
            }
            onImageLoaded: requestPaint()
            onPaint: drawImage()

            // Draw image:
            function drawImage() {
                var ctx = canvas.getContext("2d")
                ctx.fillStyle = drawWidgetStyle.bkgColor
                ctx.fillRect(0, 0, canvas.width, canvas.height)
                if (initialImage.length > 0)
                {
                    // Draw image centered:
                    ctx.drawImage(initialImage, 0, 0)
                }
                ctx.lineWidth = 1.5
                ctx.strokeStyle = drawWidgetStyle.penColor
                ctx.moveTo(lastX, lastY)
                lastX = area.mouseX
                lastY = area.mouseY
                ctx.lineTo(lastX, lastY)
                ctx.stroke()
            }

            // Handle user clicks:
            MouseArea {
                id: area
                anchors.fill: parent
                onPressed: {
                    canvas.lastX = mouseX
                    canvas.lastY = mouseY
                }
                onPositionChanged: {
                    canvas.requestPaint()
                }
            }
        }
    }

    // Style:
    DrawWidgetStyle {
        id: drawWidgetStyle
    }

    // Canvas loader:
    Loader {
        id: canvasLoader
        anchors.fill: parent
    }
}
