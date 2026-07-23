import Quickshell
import QtQuick
import QtQuick.Layouts
import "../.."

Text {
    color: Config.lockScreen.dateTextColor
    font.family: Config.fontBlocky.font.family
    font.bold: false
    font.italic: true
    font.variableAxes: {
        "wght": 400
    }
}