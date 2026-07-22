import Quickshell
import QtQuick
import "../.."

// Displays text for the system info menu
Text {
    rightPadding: 30
    leftPadding: 30
    color: Config.systemInfo.textColor
    font.family: Config.fontSansSerif.font.family
    font.bold: true
    font.letterSpacing: 2
    font.pixelSize: 50
}