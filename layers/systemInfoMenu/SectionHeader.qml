import Quickshell
import QtQuick
import Quickshell.Widgets
import "../.."

// Displays a title for a section of statistics
WrapperRectangle {
    required property string text
    color: "transparent"
    border.color: Config.systemInfo.textColor
    border.width: 4
    radius: 2
    SysInfoText {
        text: parent.text
        font.italic: true
    }
}
