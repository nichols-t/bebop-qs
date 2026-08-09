import QtQuick
import "../.."

// Text placed randomly, for the background of the app launcher screen
Text {
    required property real maxHeight
    required property real maxWidth
    required property real maxFontSize
    visible: !!text
    x: Math.random() * maxX
    y: Math.random() * randomTextContainer.height
    font.family: Config.fontBlocky.font.family
    font.pointSize: Math.random() * maxFontSize + 1
    font.italic: Math.random() > 0.5
    font.bold: Math.random() > 0.5
}
