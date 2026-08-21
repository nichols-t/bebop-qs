import Quickshell
import QtQuick
import QtQuick.Effects
import "../.."

// Displays text for the system info menu
Text {
    rightPadding: font.pixelSize
    leftPadding: font.pixelSize
    color: Config.systemInfo.textColor
    font.family: Config.fontSansSerif.font.family
    font.bold: true
    font.letterSpacing: 2
    font.pointSize: Config.systemInfo.textSize
}