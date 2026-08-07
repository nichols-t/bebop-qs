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
    // TODO bias the random so that fonts tend smaller when there are more entries
    font.pointSize: Math.random() * maxFontSize
    font.italic: Math.random() > 0.5
    font.bold: Math.random() > 0.5
}
