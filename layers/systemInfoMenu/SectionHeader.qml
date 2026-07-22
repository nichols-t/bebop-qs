import Quickshell
import QtQuick
import Quickshell.Widgets
import "../.."

// Displays a title for a section of statistics
SectionHeaderRectangle {
    required property string text
    SysInfoText {
        text: parent.text
        font.italic: true
    }
    component SectionHeaderRectangle: WrapperRectangle {
        color: "transparent"
        border.color: Config.systemInfo.textColor
        border.width: 4
        radius: 2
    }
}
