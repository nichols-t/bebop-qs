
import Quickshell.Widgets
import QtQuick
import "../.."

WrapperRectangle {
    color: "transparent"
    id: root
    required property string text
    property bool hovered: false
    Text {
        text: root.text
        color: Config.settings.menuTextColor
        horizontalAlignment: Text.AlignHCenter
        font.family: Config.fontBlocky.font.family
        font.pointSize: Config.settings.menuTextSize
        font.bold: false
        font.italic: root.hovered
        font.letterSpacing: 2
    }
}
